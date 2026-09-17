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
      url "https://github.com/3leaps/sfetch/releases/download/v0.4.12/sfetch_darwin_arm64.tar.gz"
      sha256 "8065a7fa75afa0601899798e4da96f9f08c64ffaedd3dc71a08071d8533b76a8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/sfetch/releases/download/v0.4.12/sfetch_linux_amd64.tar.gz"
      sha256 "216e1b8b887e1207b403040de3da07bee41c13e3c74c6f38673efa3141604181"
    end

    on_arm do
      url "https://github.com/3leaps/sfetch/releases/download/v0.4.12/sfetch_linux_arm64.tar.gz"
      sha256 "477ebde53cdf837e5954d78a4c271c6831de4fbd5dd0770f8f449cbf1b3edf6c"
    end
  end

  def install
    bin.install "sfetch"
  end

  test do
    system bin/"sfetch", "--version"
  end
end
