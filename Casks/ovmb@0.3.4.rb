require_relative "../lib/private_strategy"

cask "ovmb@0.3.4" do
  name "ovmb"
  desc "Oceanus VM Bootstrapper"
  homepage "https://github.com/iconik-io/oceanus_ovmb"
  version "0.3.4"

  depends_on cask: "1password-cli"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.4/oceanus_ovmb_0.3.4_darwin_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "7d746320189dca02719896b409db7ea94d81cc64f2e15d5baf6994a738abfc7b"
  elsif OS.mac? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.4/oceanus_ovmb_0.3.4_darwin_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "280af06aed14d9f00ba13229913be96f7cfccd2fd1c0f582acae671d36289d8f"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.4/oceanus_ovmb_0.3.4_linux_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "44ce0536ab51d1412457fcefd01db13702ff2a6c2c66c84cb602995841a464a0"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.4/oceanus_ovmb_0.3.4_linux_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "186b07951e496d799f29b1586917cd188bf9037da0da95dec6a41b6ad802ccac"
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
