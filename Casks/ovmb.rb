require_relative "../lib/private_strategy"

cask "ovmb" do
  name "ovmb"
  desc "Oceanus VM Bootstrapper"
  homepage "https://github.com/iconik-io/oceanus_ovmb"
  version "0.3.7"

  depends_on cask: "1password-cli"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.7/oceanus_ovmb_0.3.7_darwin_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "fc08d524cbfaae5effd7d7dd8fc766691b5846a03fb062731f79841f5559d56c"
  elsif OS.mac? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.7/oceanus_ovmb_0.3.7_darwin_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "2033b3e3d12175800876aa0e34dd656d214dcf883033fedf255bee447c8d6113"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.7/oceanus_ovmb_0.3.7_linux_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "a2495eb91efcbda5e4b49b21352e644a0e76af43ca04c81bb81b1c2c46b7036c"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.7/oceanus_ovmb_0.3.7_linux_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "a9a403657f33aa4133920db826f6a03cd2c79a030699777423ccff0225bce250"
  end

  # This block explicitly handles the installation of the binary
  installer script: {
    executable: "mv",
    args:       ["#{staged_path}/ovmb", "#{HOMEBREW_PREFIX}/bin/ovmb"],
  }

  # This block is crucial for brew uninstall and brew upgrade
  uninstall script: {
    executable: "rm",
    args:       ["-f", "#{HOMEBREW_PREFIX}/bin/ovmb"],
  }

  postflight do
    # This command removes the macOS quarantine attribute, stopping the security warning
    system_command "xattr", args: ["-d", "com.apple.quarantine", "#{HOMEBREW_PREFIX}/bin/ovmb"], sudo: false
    
    # This command then runs your version check
    system_command "#{HOMEBREW_PREFIX}/bin/ovmb", args: ["version"]
  end
end
