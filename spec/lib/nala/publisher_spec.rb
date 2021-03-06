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

    describe "testing usage" do
      let(:controller) { MyController.new }

      it "can be stubbed and event handlers called" do
        allow(SuccessClass).to receive(:call) { emit(:success) }

        controller.create

        expect(controller.success).to be(true)
        expect(controller.failure).to be(false)
      end

      it "can be stubbed and event handlers called with arguments" do
        allow(SuccessClass).to receive(:call) { emit(:success, "Andy") }

        controller.create

        expect(controller.success_args).to eq("Andy")
      end
    end
  end

  describe "#on" do
    let(:block)       { block_spy }
    let(:other_block) { block_spy }

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

    it "passes single argument to handlers" do
      PublishArgsClass.call
        .on(:single, &block.spy)

      expect(block).to be_called_with(:a)
    end

    it "passes multiple arguments to handlers" do
      PublishArgsClass.call
        .on(:multiple, &block.spy)

      expect(block).to be_called_with(:a, :b, :c)
    end
  end

  describe "#call" do
    it "ignores internal calls to #publish" do
      expect(Square.new(2).call).to eq(4)
    end
  end
end
