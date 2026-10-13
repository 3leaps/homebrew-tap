class Decernor < Formula
  desc "Local key-material hygiene and readiness checks"
  homepage "https://github.com/3leaps/decernor"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/3leaps/decernor/releases/download/v0.1.9/decernor_0.1.9_darwin_amd64.tar.gz"
      sha256 "7281cf0c1efe68801bd195b5298ae5d5cb944e38b71f0a7805fb2757fb23cbdb"
    end

    on_arm do
      url "https://github.com/3leaps/decernor/releases/download/v0.1.9/decernor_0.1.9_darwin_arm64.tar.gz"
      sha256 "3bcf59a8fc95cf6f41f64e60b566705023d5dfa6298493b62f337417888fe266"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/decernor/releases/download/v0.1.9/decernor_0.1.9_linux_amd64.tar.gz"
      sha256 "59952ee941632b938b8096cdec3cd86a448a6badcfa673093dfdad283794a606"
    end

    on_arm do
      url "https://github.com/3leaps/decernor/releases/download/v0.1.9/decernor_0.1.9_linux_arm64.tar.gz"
      sha256 "3ac07f47d30d91e59caa1a025f6cea1184fe09cf778509e66491c5e1c7743505"
    end
  end

  def install
    bin.install "decernor"
  end

  test do
    system bin/"decernor", "version"
  end
end
