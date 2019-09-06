require_relative "std_requirement"

class StdNodeRequirement < StdRequirement
  fatal true

  def initialize(tags)
    @with_node = tags.shift
    super(tags)
  end

  # If `which("node")` returns a value, or we built `--with-node`, then we're satisfied
  satisfy(:build_env => false) { which("node") || @with_node }

  def message; <<~EOS
    node is required.
      Install it separately into your path (via NVM or otherwise) or pass `--with-node` to install via brew.
  EOS
  end
end
