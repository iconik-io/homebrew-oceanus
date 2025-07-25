require_relative "../lib/private_strategy"

cask "ovmb@0.3.3" do
  name "ovmb"
  desc "Oceanus VM Bootstrapper"
  homepage "https://github.com/iconik-io/oceanus_ovmb"
  version "0.3.3"

  depends_on cask: "1password-cli"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.3/oceanus_ovmb_0.3.3_darwin_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "25a06d512adc77fd739fbed01236758b633d8693efeb47f31ffc337a4ad920d5"
  elsif OS.mac? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.3/oceanus_ovmb_0.3.3_darwin_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "8714dd50666ab51b1ad57311a5255f36f4e88412f271a4378a815ddd9e6e95fa"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.3/oceanus_ovmb_0.3.3_linux_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "188a1f3c7eb4ca88dd4b872dd0317cc1f404675fc2a2e354d158d249ca7e9cef"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.3/oceanus_ovmb_0.3.3_linux_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "9c0e70d18f7527ebfe72ffe210218618696b072288a7c95babdee382beb152d6"
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
