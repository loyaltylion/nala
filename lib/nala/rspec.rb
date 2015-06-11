require "rspec/expectations"

module Nala
  class BlockSpy
    attr_reader :called, :args

    def initialize
      @called = false
      @args   = []
    end

    def called!
      @called = true
    end

    def called_with!(args)
      called!
      @args = *args
    end

    def called?
      called
    end

    def spy
      proc { |*args| called_with!(args) }
    end
  end

  module RSpecHelpers
    def emit(event, *args)
      Nala::EventEmitter.new.tap do |emitter|
        emitter.store_result(event, args)
      end
    end

    def block_spy
      Nala::BlockSpy.new
    end
  end
end

RSpec.configure do |config|
  config.include Nala::RSpecHelpers
end

RSpec::Matchers.define :be_called_with do |*expected_args|
  match do |block|
    block.called? && block.args == expected_args
  end

  failure_message do |block|
    return "expected the block to be called but it was not" unless block.called?

    %(
      expected the block to be called with the arguments
      #{expected_args.inspect} but it was called with #{block.args.inspect}
    ).strip.squeeze(" ").delete("\n")
  end
end
