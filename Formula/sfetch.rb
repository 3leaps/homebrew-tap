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
      url "https://github.com/3leaps/sfetch/releases/download/v0.4.13/sfetch_darwin_arm64.tar.gz"
      sha256 "20f68dfc7aa6ee3df9564f7912b466bf51087a54edb1a671c72dc8ae05560f9c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/sfetch/releases/download/v0.4.13/sfetch_linux_amd64.tar.gz"
      sha256 "d535ec2260cdbdaf9eadfa2881b3a149c63725e0fee2f141b7a5ced3b975cbec"
    end

    on_arm do
      url "https://github.com/3leaps/sfetch/releases/download/v0.4.13/sfetch_linux_arm64.tar.gz"
      sha256 "76da09f2b3a7fc51db5400f460e4372f791e7e2d8f12697a8143daa48dc07307"
    end
  end

  def install
    bin.install "sfetch"
  end

  test do
    system bin/"sfetch", "--version"
  end
end
