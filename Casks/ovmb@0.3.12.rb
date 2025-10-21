$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
require "private_strategy"

cask "ovmb@0.3.12" do
  name "ovmb"
  desc "Oceanus VM Bootstrapper"
  homepage "https://github.com/iconik-io/oceanus_ovmb"
  version "0.3.12"

  depends_on cask: "1password-cli"
  depends_on formula: "gh"
  depends_on formula: "k0sproject/tap/k0sctl"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.12/oceanus_ovmb_0.3.12_darwin_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "ebb2be8c0bb6e23b313a5073ae1528acfac77b00de333381ab715bbf2f87031d"
  elsif OS.mac? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.12/oceanus_ovmb_0.3.12_darwin_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "991183c1dc6fe20811d6dd3e32330e3bd26eefc464c392a5a10ddb4db6957d41"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.12/oceanus_ovmb_0.3.12_linux_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "c610e78246955d5f795027805dc809610f8538a74f24022e607e1d055a4f4a0a"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.12/oceanus_ovmb_0.3.12_linux_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "9ce9f6de30a1ad00115fd02b1b84f04c2be10e09371d389db06b373c2c5c2244"
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
