$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
require "private_strategy"

cask "ovmb@0.3.11" do
  name "ovmb"
  desc "Oceanus VM Bootstrapper"
  homepage "https://github.com/iconik-io/oceanus_ovmb"
  version "0.3.11"

  depends_on cask: "1password-cli"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.11/oceanus_ovmb_0.3.11_darwin_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "191dca6c0a0984e9f8400129f53f98d8a9c3f6e7f30fa52f259a2f80d05b20aa"
  elsif OS.mac? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.11/oceanus_ovmb_0.3.11_darwin_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "1fddb82e7ddbf8eec2be213dca2922ca3aa28616fbcf6e6f20469d4104e6ba55"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.11/oceanus_ovmb_0.3.11_linux_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "5427a60191590b351c5b22a6fc489f8025386b82c728e1df16878406beceb8da"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.11/oceanus_ovmb_0.3.11_linux_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "192c8b3d5aabe6cebf283649545cf2dbe96c53e44a64eca4d65ec75104e42c97"
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
