class Decernor < Formula
  desc "Local key-material hygiene and readiness checks"
  homepage "https://github.com/3leaps/decernor"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/3leaps/decernor/releases/download/v0.1.7/decernor_0.1.7_darwin_amd64.tar.gz"
      sha256 "5324555d3d2439478afffa57bcaafebcb1e6592894b0bdcac091210feffb5174"
    end

    on_arm do
      url "https://github.com/3leaps/decernor/releases/download/v0.1.7/decernor_0.1.7_darwin_arm64.tar.gz"
      sha256 "dcd2d1b7d39e6489954bb21938c9a250de5519dc5f2baa64fd0f8a9d2d2afe04"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/decernor/releases/download/v0.1.7/decernor_0.1.7_linux_amd64.tar.gz"
      sha256 "2b3d6c5072b63b8fb956d9248b3ece3139c34054a8063679a379e6d49dc5ae70"
    end

    on_arm do
      url "https://github.com/3leaps/decernor/releases/download/v0.1.7/decernor_0.1.7_linux_arm64.tar.gz"
      sha256 "e41cc3801ccdc8e21c9934a1b4e91f81111ede421d3448b8740ca76cb63c8f09"
    end
  end

  def install
    bin.install "decernor"
  end

  test do
    system bin/"decernor", "version"
  end
end
