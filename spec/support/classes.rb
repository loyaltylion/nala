class NoArgsClass
  include Nala::Publisher

  def call
  end
end

class OneArgClass
  include Nala::Publisher

  def initialize(_)
  end

  def call
  end
end

class MultipleArgsClass
  include Nala::Publisher

  def initialize(_, _, _)
  end

  def call
  end
end

class SuccessClass
  include Nala::Publisher

  def call
    publish(:success)
  end
end

class MultiPublishClass
  include Nala::Publisher

  def call
    publish(:a)
    publish(:b)
  end
end

class PublishArgsClass
  include Nala::Publisher

  def call
    publish(:single, :a)
    publish(:multiple, :a, :b, :c)
  end
end
