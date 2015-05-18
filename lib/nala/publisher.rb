module Nala
  module Publisher
    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      def call(*args)
        EventEmitter.new.tap do |emitter|
          new(*args).listen_with(emitter).call
        end
      end
    end

    def listen_with(emitter)
      @emitter = emitter

      self
    end

    def publish(event, *args)
      emitter.store_result(event, args)
    end

    private

    attr_reader :emitter
  end
end
