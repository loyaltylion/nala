module Nala
  module Publisher
    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      def call
        new.call
      end
    end
  end
end
