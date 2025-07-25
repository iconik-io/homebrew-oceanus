require_relative "../lib/private_strategy"

cask "ovmb" do
  name "ovmb"
  desc "Oceanus VM Bootstrapper"
  homepage "https://github.com/iconik-io/oceanus_ovmb"
  version "0.3.2"

  depends_on cask: "1password-cli"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.2/oceanus_ovmb_0.3.2_darwin_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "453d98eb7465b20e6d56882191a722a9ca2e99252a7ac328129a668d9779d38e"
  elsif OS.mac? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.2/oceanus_ovmb_0.3.2_darwin_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "f80ac2df315541a452b339e523213135a060f172e3313fb868c419261f881437"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.2/oceanus_ovmb_0.3.2_linux_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "20f80915a79ec5a1009ae67f2bd105a614f157409b491f45ae63f924fe787856"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.2/oceanus_ovmb_0.3.2_linux_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "c52d55e29b230e3eb487f327c884cae4e956e1c11c744f8a384ae39074451c0a"
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
