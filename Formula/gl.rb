class Gl < Formula
  desc "Great Love CLI: personal developer workflow orchestrator"
  homepage "https://github.com/nobottomline/gl"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nobottomline/gl/releases/download/v0.1.0/gl-aarch64-apple-darwin.tar.xz"
      sha256 "d2bcb73ec0045ae9ed18acba32a9316d1d74d80626af205b3aab2de99ea8c76f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nobottomline/gl/releases/download/v0.1.0/gl-x86_64-apple-darwin.tar.xz"
      sha256 "6fd183c99ddaa88c84bfe27eba23d4cab2c39d1415ab0942d568d9ba25810947"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/nobottomline/gl/releases/download/v0.1.0/gl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "81cac8fd68d9946afc5f531bb935013afdb51c288f878e720a951af20888b679"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "gl" if OS.mac? && Hardware::CPU.arm?
    bin.install "gl" if OS.mac? && Hardware::CPU.intel?
    bin.install "gl" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
