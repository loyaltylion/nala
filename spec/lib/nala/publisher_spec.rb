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

RSpec.describe Nala::Publisher do
  describe ".call" do
    context "with no arguments" do
      it "instantiates and invokes #call" do
        instance = spy
        allow(NoArgsClass).to receive(:new) { instance }

        NoArgsClass.call

        expect(instance).to have_received(:call)
      end
    end

    context "with an argument" do
      it "instantiates and invokes #call with the same arguments" do
        instance = spy
        allow(OneArgClass).to receive(:new) { instance }

        OneArgClass.call(:hello)

        expect(instance).to have_received(:call).with(:hello)
      end
    end
  end
end
