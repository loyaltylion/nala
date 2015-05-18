class MyClass
  include Nala::Publisher

  def call
    publish(:ok)
  end
end

RSpec.describe Nala::Publisher do
  describe ".call" do
    context "with no arguments" do
      it "instantiates and invokes #call" do
        instance = spy
        allow(MyClass).to receive(:new) { instance }

        MyClass.call

        expect(instance).to have_received(:call)
      end
    end
  end
end
