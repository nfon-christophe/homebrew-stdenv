require_relative "std_requirement"

class StdGoRequirement < StdRequirement
  fatal true

  def initialize(tags)
    @with_go = tags.shift
    super(tags)
  end

  # If `which("go")` returns a value, or we built `--with-go`, then we're satisfied
  satisfy(:build_env => false) { which("go") || @with_go }

  def message; <<~EOS
    go is required.
      Install it separately into your path or pass `--with-go` to install via brew.
  EOS
  end
end
