class Seclusor < Formula
  desc "seclusor command-line tool"
  homepage "https://github.com/3leaps/seclusor"
  version "0.1.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/3leaps/seclusor/releases/download/v0.1.5/seclusor-darwin-arm64"
      sha256 "f51cf9a9d1cad8ae04f71244ffba7b153e2086379d6f1936a7c3e595de1cf810"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/seclusor/releases/download/v0.1.5/seclusor-linux-amd64"
      sha256 "52eab79141698ada94057abb780f5d06049fde751fd694a39bff56a492f87db3"
    end

    on_arm do
      url "https://github.com/3leaps/seclusor/releases/download/v0.1.5/seclusor-linux-arm64"
      sha256 "1579641f58dd3baa8a8cbae235abb7f8ef93625f116a89bc39542c4005b7d190"
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
