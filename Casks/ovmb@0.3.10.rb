17854LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
require "private_strategy"

cask "ovmb@0.3.10" do
  name "ovmb"
  desc "Oceanus VM Bootstrapper"
  homepage "https://github.com/iconik-io/oceanus_ovmb"
  version "0.3.10"

  depends_on cask: "1password-cli"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.10/oceanus_ovmb_0.3.10_darwin_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "ff1c515f1e5c89164a43432831c2afaf3440c69899c3d5cd5f6a4032aad24126"
  elsif OS.mac? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.10/oceanus_ovmb_0.3.10_darwin_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "69302f0e22bc03d59dc7290b86387dbe0546a699544aebdacf681dd5d9a0b923"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.10/oceanus_ovmb_0.3.10_linux_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "55a9c4df655085b267c36dc7d430e3876624f5b4c56e209c0bf72eee93168b94"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.10/oceanus_ovmb_0.3.10_linux_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "6e278d1c0eb073fae14158755f4f563c871457cbc1e4397f9b04d7bb851d0409"
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
