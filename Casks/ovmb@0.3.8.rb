require_relative "../lib/private_strategy"

cask "ovmb@0.3.8" do
  name "ovmb"
  desc "Oceanus VM Bootstrapper"
  homepage "https://github.com/iconik-io/oceanus_ovmb"
  version "0.3.8"

  depends_on cask: "1password-cli"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.8/oceanus_ovmb_0.3.8_darwin_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "48aa2b173533fc72f2cbb11116e712dd89dbcf7f255470bb19f431ae3dd298e6"
  elsif OS.mac? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.8/oceanus_ovmb_0.3.8_darwin_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "ac3bd29531d57501d1915ddc756e9e3203b74cbff847d21bebe2b017937d7348"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.8/oceanus_ovmb_0.3.8_linux_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "daf6e6382305072993ede30f39a6a7a25859caac93c355f10b6073d08c65f2b1"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.8/oceanus_ovmb_0.3.8_linux_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "0e10eb8fc9d990b73f72a3eb88b85c8295ae3e049054622c731256941e240f53"
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
