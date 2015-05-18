class NoArgsClass
  include Nala::Publisher

  def call
  end
end

class OneArgClass
  include Nala::Publisher

  def call(_)
  end
end

class MultipleArgsClass
  include Nala::Publisher

  def call(_, _, _)
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

class BlockSpy
  attr_reader :called

  def initialize
    @called = false
  end

  def called!
    @called = true
  end

  def called?
    @called
  end
end

RSpec.describe Nala::Publisher do
  describe ".call" do
    let(:instance) { spy }

    context "with no arguments" do
      it "instantiates and invokes #call" do
        expect(NoArgsClass).to receive(:new).with(no_args) { instance }
        expect(instance).to receive(:call)

        NoArgsClass.call
      end
    end

    context "with an argument" do
      it "instantiates with the same argument and invokes #call" do
        expect(OneArgClass).to receive(:new).with(:hello) { instance }
        expect(instance).to receive(:call)

        OneArgClass.call(:hello)
      end
    end

    context "with multiple arguments" do
      it "instantiates with the same arguments and invokes #call" do
        expect(MultipleArgsClass).to receive(:new).with(:a, :b, :c) { instance }
        expect(instance).to receive(:call)

        MultipleArgsClass.call(:a, :b, :c)
      end
    end
  end

  context "#on" do
    let(:block) { BlockSpy.new }
    let(:other_block) { BlockSpy.new }

    it "invokes a handler for a published event" do
      SuccessClass.call.on(:success) { block.called! }

      expect(block).to be_called
    end

    it "does not invoke a handler for an unpublished event" do
      SuccessClass.call.on(:failure) { block.called! }

      expect(block).not_to be_called
    end

    it "invokes multiple handlers when all are published" do
      MultiPublishClass.call
        .on(:a) { block.called! }
        .on(:b) { other_block.called! }

      expect(block).to be_called
      expect(other_block).to be_called
    end
  end
end
