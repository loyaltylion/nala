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

    before { allow(use_case_class).to receive(:new) { instance } }

    context "with no arguments" do
      let(:use_case_class) { NoArgsClass }

      it "instantiates and invokes #call" do
        use_case_class.call

        expect(instance).to have_received(:call)
      end
    end

    context "with an argument" do
      let(:use_case_class) { OneArgClass }

      it "instantiates and invokes #call with the same argument" do
        use_case_class.call(:hello)

        expect(instance).to have_received(:call).with(:hello)
      end
    end

    context "with multiple arguments" do
      let(:use_case_class) { MultipleArgsClass }

      it "instantiates and invokes #call with the same arguments" do
        use_case_class.call(:hello, :there, :world)

        expect(instance).to have_received(:call).with(:hello, :there, :world)
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
