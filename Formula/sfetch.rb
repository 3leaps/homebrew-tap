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
      url "https://github.com/3leaps/sfetch/releases/download/v0.4.16/sfetch_darwin_arm64.tar.gz"
      sha256 "de6eaa260a519053bc9010bf4329f5825da69430ae8c8963f3a6fc3429e380d8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/sfetch/releases/download/v0.4.16/sfetch_linux_amd64.tar.gz"
      sha256 "b32902e3adfa8d21b038aa1566fa5baa8a3beb691cba6f30906bdaf3525b3b60"
    end

    on_arm do
      url "https://github.com/3leaps/sfetch/releases/download/v0.4.16/sfetch_linux_arm64.tar.gz"
      sha256 "6f08db8b1216737cec6d79db286d1a46f7fbf5aa58740bc8a5b19ad5be6b8eed"
    end
  end

  def install
    bin.install "sfetch"
  end

  test do
    system bin/"sfetch", "--version"
  end
end
