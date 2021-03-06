module Nala
  class EventEmitter
    def initialize
      @events = {}
    end

    def store_result(event, args)
      events[event] = args
    end

    def on(event)
      yield(*events[event]) if events.key?(event)

      self
    end

    private

    attr_reader :events
  end
end
