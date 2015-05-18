module Nala
  module Publisher
    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      def call(*args)
        new.call(*args)
      end
    end
  end
end
