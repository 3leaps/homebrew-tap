class Decernor < Formula
  desc "Local key-material hygiene and readiness checks"
  homepage "https://github.com/3leaps/decernor"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/3leaps/decernor/releases/download/v0.1.8/decernor_0.1.8_darwin_amd64.tar.gz"
      sha256 "4123d00c5616778482b1abf9470d1ae21271093c9eb47e23e6f59567e60f4e15"
    end

    on_arm do
      url "https://github.com/3leaps/decernor/releases/download/v0.1.8/decernor_0.1.8_darwin_arm64.tar.gz"
      sha256 "e3f776fdf779e7b62dced136677fc1b9491042cee1cc54b3ecf896b9b3345769"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/decernor/releases/download/v0.1.8/decernor_0.1.8_linux_amd64.tar.gz"
      sha256 "2f034a1945772983e39dae7143ac2f5ba2c3aa79aa249902fb585960a4582261"
    end

    on_arm do
      url "https://github.com/3leaps/decernor/releases/download/v0.1.8/decernor_0.1.8_linux_arm64.tar.gz"
      sha256 "0ce0a48d51e1a2fec9ef68aa78eaee4786f48fb541d115bb6184da2e02fc97d7"
    end
  end

  def install
    bin.install "decernor"
  end

  test do
    system bin/"decernor", "version"
  end
end
