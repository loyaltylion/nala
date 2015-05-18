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

  context "#call" do
    it "invokes a handler" do
      called = false

      SuccessClass.call.on(:success) { called = true }

      expect(called).to be(true)
    end
  end
end
