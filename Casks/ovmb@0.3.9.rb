.unshift(File.expand_path('../lib', __dir__))
require "private_strategy"

cask "ovmb@0.3.9" do
  name "ovmb"
  desc "Oceanus VM Bootstrapper"
  homepage "https://github.com/iconik-io/oceanus_ovmb"
  version "0.3.9"

  depends_on cask: "1password-cli"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.9/oceanus_ovmb_0.3.9_darwin_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "f817c03a53c47b34e714bb265565fd3fe76f6aa571e6363816b9311942f51d79"
  elsif OS.mac? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.9/oceanus_ovmb_0.3.9_darwin_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "30aab1f98a7b9da0ce8ea8335ee90c5e6345fcce4414e63052409e00287cb1a4"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.9/oceanus_ovmb_0.3.9_linux_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "6204b120c69f1151a5e78d95743de26fa866d375bfb3a730fb78d6362e849dfd"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.9/oceanus_ovmb_0.3.9_linux_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "62db1d1bf184c5ac2fbf6d55b1333f8983961ba11c44662034398183ad458d82"
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
