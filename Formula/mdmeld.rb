class Mdmeld < Formula
  desc "Pack directory trees into markdown archives for AI sharing"
  homepage "https://github.com/3leaps/mdmeld"
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/3leaps/mdmeld/releases/download/v0.2.0/mdmeld-darwin-arm64"
      sha256 "c6efa4623589cd2bff557db984ce83da864a3538dadb3bac89cbb2fa12bce36a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/mdmeld/releases/download/v0.2.0/mdmeld-linux-amd64"
      sha256 "847f4db74d70ca74a754634642a2f13b0f8aaa9c7f6b5e4d57b49f2f73a8e807"
    end

    on_arm do
      url "https://github.com/3leaps/mdmeld/releases/download/v0.2.0/mdmeld-linux-arm64"
      sha256 "a5b0385ae8098050264d79cb98aa577e9d387b3b081664fd3f99e2a5f71f35fb"
    end
  end

  def install
    bin.install "mdmeld-#{platform_suffix}" => "mdmeld"
  end

  test do
    system bin/"mdmeld", "--help"
  end

  private

  def platform_suffix
    return "darwin-arm64" if OS.mac? && Hardware::CPU.arm?
    return "darwin-amd64" if OS.mac?
    return "linux-arm64" if Hardware::CPU.arm?

    "linux-amd64"
  end
end
