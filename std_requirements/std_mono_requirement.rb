require_relative "std_requirement"

class StdMonoRequirement < StdRequirement
  fatal true

  def initialize(tags)
    @with_mono = tags.shift
    super(tags)
  end

  # If `which("mono")` returns a value, or we built `--with-mono`, then we're satisfied
  satisfy(:build_env => false) { which("mono") || @with_mono }

  def message; <<~EOS
    mono is required.
      Install it separately into your path or pass `--with-mono` to install via brew.
  EOS
  end
end
