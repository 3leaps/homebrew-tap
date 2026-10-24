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
      url "https://github.com/3leaps/sfetch/releases/download/v0.4.15/sfetch_darwin_arm64.tar.gz"
      sha256 "4460426d559f22e8e7dcc6dd873cb27610233c365c4a9b63a7f9c3868629a2f3"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/sfetch/releases/download/v0.4.15/sfetch_linux_amd64.tar.gz"
      sha256 "31a2ddc6b23dfe38db3e4c65986e0394358015a6f0c821181471b0dd2a9218c0"
    end

    on_arm do
      url "https://github.com/3leaps/sfetch/releases/download/v0.4.15/sfetch_linux_arm64.tar.gz"
      sha256 "6562038d3b291ed99faf03816aed2fe029385722ad9fac44284f4f9d709ca331"
    end
  end

  def install
    bin.install "sfetch"
  end

  test do
    system bin/"sfetch", "--version"
  end
end
