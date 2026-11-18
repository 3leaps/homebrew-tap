class Yamlprims < Formula
  desc "Memory-safe YAML 1.2 Core reader, writer and I-JSON projection"
  homepage "https://github.com/3leaps/yamlprims"
  license any_of: ["MIT", "Apache-2.0"]

  # No darwin-amd64 binary is published. The head spec gives unsupported
  # platforms a buildable fallback and keeps tap-wide readall checks valid.
  head "https://github.com/3leaps/yamlprims.git", branch: "main"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/3leaps/yamlprims/releases/download/v0.3.0/yamlprims-0.3.0-darwin-arm64.tar.gz"
      sha256 "49f13282a221e1945029532a7a236bb1ad4381a94f0053cca37b87637d973b39"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/yamlprims/releases/download/v0.3.0/yamlprims-0.3.0-linux-amd64.tar.gz"
      sha256 "88aa5f3db0990291b12bdebe9d652cf0bede44e777d934944ccb92efffe63389"
    end

    on_arm do
      url "https://github.com/3leaps/yamlprims/releases/download/v0.3.0/yamlprims-0.3.0-linux-arm64.tar.gz"
      sha256 "90e70be61aaf461cb931af14456bb85bb46605997c138ae650a68a20e74b1574"
    end
  end

  def install
    bin.install "yamlprims"
  end

  test do
    system bin/"yamlprims", "--version"
  end
end
