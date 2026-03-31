class Seclusor < Formula
  desc "seclusor command-line tool"
  homepage "https://github.com/3leaps/seclusor"
  version "0.1.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/3leaps/seclusor/releases/download/v0.1.3/seclusor-darwin-arm64"
      sha256 "e30144a6959ec96179a9296e72c3e1aa256742c07e524c45d2626e214aa55b87"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/seclusor/releases/download/v0.1.3/seclusor-linux-amd64"
      sha256 "cd79ad387ac34d5588d6737908b8e15446295960485ec67408752238e81edafb"
    end

    on_arm do
      url "https://github.com/3leaps/seclusor/releases/download/v0.1.3/seclusor-linux-arm64"
      sha256 "8c91c89be56de5876cc9336c3032101bdd336cd7265a3aea1dd09a03a206d5a0"
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
