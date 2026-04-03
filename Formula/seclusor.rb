class Seclusor < Formula
  desc "Git-trackable secrets management with age encryption"
  homepage "https://github.com/3leaps/seclusor"
  version "0.1.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/3leaps/seclusor/releases/download/v0.1.6/seclusor-darwin-arm64"
      sha256 "da4164021761cd0f36c7962d86afa8c601c6a6dff953b3a20027fc5d755302d9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/seclusor/releases/download/v0.1.6/seclusor-linux-amd64"
      sha256 "91f41173f0bb2319bc29e7236cdbb25c0bb0280d6b44c0177ff4f40cadf0b9b4"
    end

    on_arm do
      url "https://github.com/3leaps/seclusor/releases/download/v0.1.6/seclusor-linux-arm64"
      sha256 "4898b8faf2f440b6900d51b27a6be2ee23dc56487cfafd731788224f085bc28a"
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
