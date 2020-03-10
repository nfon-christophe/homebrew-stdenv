require_relative "../std_requirements/std_mono_requirement"

# https://github.com/Homebrew/homebrew-core/blob/master/Formula/docfx.rb
class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/releases/download/v2.50/docfx.zip"
  sha256 "a291a16316384435a955bd75b9d415da4916d9e1b9717b0f4a43111a9f7aa7e4"

  bottle :unneeded

  depends_on "mono" => :optional # Make mono optional so it's not installed by default & we get --with-mono
  depends_on StdMonoRequirement => [build.with?("mono"), :build] # StdMonoRequirement looks for mono in std environment

  def install
    libexec.install Dir["*"]

    (bin/"docfx").write <<~EOS
      #!/bin/bash
      mono #{libexec}/docfx.exe "$@"
    EOS
  end

  test do
    system bin/"docfx", "init", "-q"
    assert_predicate testpath/"docfx_project/docfx.json", :exist?,
                     "Failed to generate project"
  end
end
