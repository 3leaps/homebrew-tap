class Kitfly < Formula
  desc "Turn your writing into a website"
  homepage "https://github.com/3leaps/kitfly"
  version "0.2.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/3leaps/kitfly/releases/download/v0.2.4/kitfly-darwin-arm64"
      sha256 "e2ab9d07dc5692648da6b5df0472174b7a41497184f2b5d5e43bae76fc15322b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/kitfly/releases/download/v0.2.4/kitfly-linux-amd64"
      sha256 "d12e90d20df569ee131ab166b0449dcb2cf8126804f6fb64aa28e92a9855dc82"
    end

    on_arm do
      url "https://github.com/3leaps/kitfly/releases/download/v0.2.4/kitfly-linux-arm64"
      sha256 "ece3a5b514236927a872b5f4c60f6f0a69e5fa660499a6c4950d8e53d5e854cc"
    end
  end

  def install
    bin.install "kitfly-#{platform_suffix}" => "kitfly"
  end

  test do
    system bin/"kitfly", "--version"
  end

  private

  def platform_suffix
    return "darwin-arm64" if OS.mac? && Hardware::CPU.arm?
    return "darwin-amd64" if OS.mac?
    return "linux-arm64" if Hardware::CPU.arm?

    "linux-amd64"
  end
end
