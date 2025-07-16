require_relative "../lib/private_strategy"

cask "ovmb" do
  name "ovmb"
  desc "Oceanus VM Bootstrapper"
  homepage "https://github.com/iconik-io/oceanus_ovmb"
  version "0.2.4"

  depends_on cask: "1password-cli"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.2.4/oceanus_ovmb_0.2.4_darwin_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 ""
  elsif OS.mac? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.2.4/oceanus_ovmb_0.2.4_darwin_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 ""
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.2.4/oceanus_ovmb_0.2.4_linux_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 ""
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.2.4/oceanus_ovmb_0.2.4_linux_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 ""
  end

  binary "ovmb"

  postflight do
    # This command removes the macOS quarantine attribute, stopping the security warning
    system_command "xattr", args: ["-d", "com.apple.quarantine", "#{staged_path}/ovmb"]
    
    # This command then runs your version check
    system_command "#{staged_path}/ovmb", args: ["--version"]
  end
end
