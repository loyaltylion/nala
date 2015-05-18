class BlockSpy
  attr_reader :called, :args

  def initialize
    @called = false
    @args = []
  end

  def called!
    @called = true
  end

  def called_with!(args)
    called!
    @args = *args
  end

  def called?
    @called
  end
end
