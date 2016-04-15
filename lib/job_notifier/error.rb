module JobNotifier
  module Error
    class InvalidIdentifier < Exception
      def initialize
        super("you need to pass a non blank identifier")
      end
    end

    class MissingAttributes < Exception
      def initialize
        super("you need to execute indentify_by method on host model")
      end
    end

    class BlankAttribute < Exception
      def initialize(attribute)
        super("#{attribute} cant be blank")
      end
    end

    class Validation < Exception
      attr_reader :error

      def initialize(error)
        super
        @error = error
      end
    end
  end
end
