class Sfetch < Formula
  desc "Secure and verifiable release-asset downloader"
  homepage "https://github.com/3leaps/sfetch"
  license "MIT"

  # No darwin-amd64 binary is published. The head spec gives unsupported
  # platforms a buildable fallback and keeps tap-wide readall checks valid.
  head "https://github.com/3leaps/sfetch.git", branch: "main"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/3leaps/sfetch/releases/download/v0.4.17/sfetch_darwin_arm64.tar.gz"
      sha256 "2220d697cbdcc683b3a5ba6a62d08af959385fcbcd2cdffbfaad74461a5e4c59"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/sfetch/releases/download/v0.4.17/sfetch_linux_amd64.tar.gz"
      sha256 "73b43658cfb63a7cb16b494cbd40084c9ff8a00cc825ec62453b36024b48519c"
    end

    on_arm do
      url "https://github.com/3leaps/sfetch/releases/download/v0.4.17/sfetch_linux_arm64.tar.gz"
      sha256 "5e6288e5fa6102677d3320737887957f9fb2ccdc73d0075f1ce1ff47b3f2a195"
    end
  end

  def install
    bin.install "sfetch"
  end

  test do
    system bin/"sfetch", "--version"
  end
end
