require "download_strategy"
require "open3"

class GitHubPrivateDownloadStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    parse_url_pattern
    set_github_token
  end

  def parse_url_pattern
    url_pattern = %r{https://github.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(\S+)}
    unless @url =~ url_pattern
      raise CurlDownloadStrategyError, "Invalid url pattern for GitHub Release."
    end
    _, @owner, @repo, @tag, @filename = *@url.match(url_pattern)
  end

  def download_url
    "https://#{@github_token}@api.github.com/repos/#{@owner}/#{@repo}/releases/assets/#{asset_id}"
  end

  private

  def _fetch(url:, resolved_url:, timeout:)
    curl_download download_url, "--header", "Accept: application/octet-stream", to: temporary_path
  end

  def asset_id
    @asset_id ||= resolve_asset_id
  end

  def resolve_asset_id
    release_metadata = fetch_release_metadata
    assets = release_metadata["assets"].select { |a| a["name"] == @filename }
    raise CurlDownloadStrategyError, "Asset file not found." if assets.empty?
    assets.first["id"]
  end

  def fetch_release_metadata
    release_url = "https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@tag}"
    GitHub::API.open_rest(release_url)
  end

  def set_github_token
    # --- Configuration for 1Password ---
    vault_name = "iconik - iconik-dev-vault"
    item_name  = "DevEx-Install-OVMB GitHub Token"
    field_name = "token"

    # Construct the 1Password secret reference URI
    op_uri = "op://#{vault_name}/#{item_name}/#{field_name}"

    # Build the full path to the op executable
    op_executable = "#{HOMEBREW_PREFIX}/bin/op"

    # Execute the 'op' command to read the secret
    stdout, stderr, status = Open3.capture3(op_executable, "read", op_uri)

    # 🔑 Error handling and token assignment
    unless status.success?
      raise CurlDownloadStrategyError, "1Password CLI failed to get token. Error:\n#{stderr}"
    end

    @github_token = stdout.chomp
    if @github_token.empty?
      raise CurlDownloadStrategyError, "Token fetched from 1Password is empty. Check item: '#{item_name}'."
    end
  end
end