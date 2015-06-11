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

class Square
  include Nala::Publisher

  attr_reader :number

  def initialize(number)
    @number = number
  end

  def call
    (number * number).tap do |answer|
      publish(:ok, answer)
    end
  end
end

class MyController
  attr_accessor :success, :failure, :success_args

  def initialize
    @success = false
    @failure = false
  end

  def create
    SuccessClass.call
      .on(:success) do |name|
        self.success = true
        self.success_args = name
      end
      .on(:failure) { self.failure = true }
  end
end
