class NodeRequirement < Requirement
  fatal true

  def initialize(tags)
    @with_node = tags.shift
    super(tags)
  end

  # If `which("node")` returns a value, or we built `--with-node`, then we're ok
  satisfy(:build_env => false) { which("node") || @with_node }

  def message; <<~EOS
    node is required;
    install it into your path (via NVM or otherwise) or re-run:
      brew install gfguthrie/stdenv/yarn --with-node
  EOS
  end
end

# https://github.com/Homebrew/homebrew-core/blob/master/Formula/yarn.rb
class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  # Should only be updated if the new version is listed as a stable release on the homepage
  url "https://yarnpkg.com/downloads/1.17.3/yarn-v1.17.3.tar.gz"
  sha256 "e3835194409f1b3afa1c62ca82f561f1c29d26580c9e220c36866317e043c6f3"

  bottle :unneeded

  # Use the std environment, so we have access to our PATH
  env :std

  # Make the node dependency optional
  depends_on "node" => :optional
  # Pass whether we're building with the node option to our Requirement
  depends_on NodeRequirement => build.with?("node")

  conflicts_with "hadoop", :because => "both install `yarn` binaries"

  def install
    libexec.install Dir["*"]
    (bin / "yarn").write_env_script "#{libexec}/bin/yarn.js", :PREFIX => HOMEBREW_PREFIX, :NPM_CONFIG_PYTHON => "/usr/bin/python"
    (bin / "yarnpkg").write_env_script "#{libexec}/bin/yarn.js", :PREFIX => HOMEBREW_PREFIX, :NPM_CONFIG_PYTHON => "/usr/bin/python"
    inreplace "#{libexec}/package.json", '"installationMethod": "tar"', '"installationMethod": "homebrew"'
  end

  test do
    (testpath / "package.json").write('{"name": "test"}')
    system bin / "yarn", "add", "jquery"
    system bin / "yarn", "add", "fsevents", "--build-from-source=true"
  end
end
