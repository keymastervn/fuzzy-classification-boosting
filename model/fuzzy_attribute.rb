class FuzzyAttribute
  attr_accessor :beta, :alpha, :certainty_factor

  def initialize
    @beta = 0
    @alpha = 0
    @certainty_factor = 0
  end

  def set_beta(v)
    @beta = v
  end

  def get_beta
    @beta
  end

  def add_beta(v)
    @beta = @beta + v
  end

  def set_certainty_factor(v)
    @certainty_factor = v
  end

  def get_certainty_factor
    @certainty_factor
  end

  def set_alpha(v)
    @alpha = v
  end

  def get_alpha
    @alpha
  end
end