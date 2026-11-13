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
      url "https://github.com/3leaps/yamlprims/releases/download/v0.2.1/yamlprims-0.2.1-darwin-arm64.tar.gz"
      sha256 "430a80ae6b267b3d5066e32b7f1c0aa2509192dceceb4094b63f09b24a6e2cf4"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/yamlprims/releases/download/v0.2.1/yamlprims-0.2.1-linux-amd64.tar.gz"
      sha256 "08decf02549acf6b0e15c56848d6030aedf8ccfabe6ec6ead8a6ef8ee45644a2"
    end

    on_arm do
      url "https://github.com/3leaps/yamlprims/releases/download/v0.2.1/yamlprims-0.2.1-linux-arm64.tar.gz"
      sha256 "b4ccbcd42d97aff497c3759555a079e97d7ae39415591d256b33fd404a30f5b2"
    end
  end

  def install
    bin.install "yamlprims"
  end

  test do
    system bin/"yamlprims", "--version"
  end
end
