require_relative "../lib/private_strategy"

cask "ovmb@0.3.5" do
  name "ovmb"
  desc "Oceanus VM Bootstrapper"
  homepage "https://github.com/iconik-io/oceanus_ovmb"
  version "0.3.5"

  depends_on cask: "1password-cli"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.5/oceanus_ovmb_0.3.5_darwin_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "514ef57633bc2ae0e63d5fc43601e44109f05eb815af3312ce8ca8f830004c2b"
  elsif OS.mac? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.5/oceanus_ovmb_0.3.5_darwin_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "85096ce19c9c510ad94ae05d220dc04895dafbac423af8641d93229924620b0d"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.5/oceanus_ovmb_0.3.5_linux_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "922ed7a174f94047072683ee0634026b0225b3ca16a12b9d9eaea8cabe0b608e"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.5/oceanus_ovmb_0.3.5_linux_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "34ad23ac90e10007056e5cfd875d8bebb8f14a795fcbb60862afaeee9e882c6d"
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
