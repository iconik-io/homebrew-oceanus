require_relative "../lib/private_strategy"

cask "ovmb" do
  name "ovmb"
  desc "Oceanus VM Bootstrapper"
  homepage "https://github.com/iconik-io/oceanus_ovmb"
  version "0.2.3"

  depends_on cask: "1password-cli"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.2.3/oceanus_ovmb_0.2.3_darwin_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "f1b3d1b36cc916b95ab55d2b109f27f62ec0487df7d13d74c8c6c71743f6735f"
  elsif OS.mac? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.2.3/oceanus_ovmb_0.2.3_darwin_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "c99cce2118db5b3a7347eac4b92a17fa543fcff012eb4c2f9b5dde7f991d5cca"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.2.3/oceanus_ovmb_0.2.3_linux_amd64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "e455e8c6079746f9176507de5329f906bf005f629661da1c5c245ffba717962b"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/iconik-io/oceanus_ovmb/releases/download/v0.2.3/oceanus_ovmb_0.2.3_linux_arm64.tar.gz", using: GitHubPrivateDownloadStrategy
    sha256 "4b2412e71b4d76e73d89c37b0fe17851d328f43b8d8da5c14acbcdcf29d0e16f"
  end

  binary "ovmb"

  postflight do
    system "#{bin}/ovmb", "--version"
  end
end