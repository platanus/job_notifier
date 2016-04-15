module JobNotifier
  module Error
    class InvalidIdentifier < Exception; end
    class Validation < Exception
      attr_reader :error

      def initialize(error)
         super
         @error = error
       end
    end
  end
end
