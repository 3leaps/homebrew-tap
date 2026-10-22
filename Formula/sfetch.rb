class Sfetch < Formula
  desc "Secure and verifiable release-asset downloader"
  homepage "https://github.com/3leaps/sfetch"
  license "Apache-2.0"

  # No darwin-amd64 binary is published. The head spec gives unsupported
  # platforms a buildable fallback and keeps tap-wide readall checks valid.
  head "https://github.com/3leaps/sfetch.git", branch: "main"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/3leaps/sfetch/releases/download/v0.4.14/sfetch_darwin_arm64.tar.gz"
      sha256 "2a2095ece203e72f216a5353dcb8a9f15331afd2f41d3c19bd7be3041dd4020c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/sfetch/releases/download/v0.4.14/sfetch_linux_amd64.tar.gz"
      sha256 "eccb6ab95421afafd2ce4b1d5ffa3f9d0c8fc5e1a6ec73522c8abc5d3953bd82"
    end

    on_arm do
      url "https://github.com/3leaps/sfetch/releases/download/v0.4.14/sfetch_linux_arm64.tar.gz"
      sha256 "0c197408b65c6ef6c22959acfc1da477df353487e89e07f3e12aad5dede1e58c"
    end
  end

  def install
    bin.install "sfetch"
  end

  test do
    system bin/"sfetch", "--version"
  end
end
