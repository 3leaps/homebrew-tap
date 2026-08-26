class Decernor < Formula
  desc "Local key-material hygiene and readiness checks"
  homepage "https://github.com/3leaps/decernor"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/3leaps/decernor/releases/download/v0.1.6/decernor_0.1.6_darwin_amd64.tar.gz"
      sha256 "5d747d1cdaacec782f0dbd00bda0390b4dd4801ea7f9184915ede63b193b9f53"
    end

    on_arm do
      url "https://github.com/3leaps/decernor/releases/download/v0.1.6/decernor_0.1.6_darwin_arm64.tar.gz"
      sha256 "9ca172d01d9082297baf8ddeba165a73c121713fd18c1e74ad0e3e25303e7b8a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/decernor/releases/download/v0.1.6/decernor_0.1.6_linux_amd64.tar.gz"
      sha256 "88ab3d25c6e37d18e005ccfcd6c7684758926a71f745d20bf7db3ded99e03062"
    end

    on_arm do
      url "https://github.com/3leaps/decernor/releases/download/v0.1.6/decernor_0.1.6_linux_arm64.tar.gz"
      sha256 "a6498fc5af9f855211b0096e763dfd37668aea3b249e01bff857614796c72c88"
    end
  end

  def install
    bin.install "decernor"
  end

  test do
    system bin/"decernor", "version"
  end
end
