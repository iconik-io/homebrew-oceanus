require_relative "../lib/private_strategy"

cask "ovmb@0.3.6" do
  name "ovmb"
  desc "Oceanus VM Bootstrapper"
  homepage "https://github.com/iconik-io/oceanus_ovmb"
  version "0.3.6"

  depends_on cask: "1password-cli"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.6/oceanus_ovmb_0.3.6_darwin_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "b29a21b605555efb86fe2b74c8ed2f331a5b3d3e422b9aa3b4d73a9edbb31666"
  elsif OS.mac? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.6/oceanus_ovmb_0.3.6_darwin_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "53b753429c2d9a22c2607b47ac8dba46d9a0d143e2c2df8c53d8c166831db617"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.6/oceanus_ovmb_0.3.6_linux_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "1189dd74a0b7c375c1b4f9babba637fc734931216a09c2e05046d5c6ea4cd38f"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.3.6/oceanus_ovmb_0.3.6_linux_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "c50ba1f01ba9a039c775148d3a28002a5bed444c6342e66b893cb8b992cb774c"
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
