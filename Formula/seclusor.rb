class Seclusor < Formula
  desc "seclusor command-line tool"
  homepage "https://github.com/3leaps/seclusor"
  version "0.1.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/3leaps/seclusor/releases/download/v0.1.4/seclusor-darwin-arm64"
      sha256 "35f3f35800c10980a5f0e030b9f2e8c2878fce4424e195aa9880c35004304068"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/seclusor/releases/download/v0.1.4/seclusor-linux-amd64"
      sha256 "3de94e9aafec91f1ee5498553a018fbb680fb522e58973c759b067dd6fdb5906"
    end

    on_arm do
      url "https://github.com/3leaps/seclusor/releases/download/v0.1.4/seclusor-linux-arm64"
      sha256 "204db77c01c21c35406a5a37d07d8710a03c1bead96a5c457f714998f32226a0"
    end
  end

  def install
    bin.install "seclusor-#{platform_suffix}" => "seclusor"
  end

  test do
    system bin/"seclusor", "--version"
  end

  private

  def platform_suffix
    return "darwin-arm64" if OS.mac? && Hardware::CPU.arm?
    return "darwin-amd64" if OS.mac?
    return "linux-arm64" if Hardware::CPU.arm?

    "linux-amd64"
  end
end
