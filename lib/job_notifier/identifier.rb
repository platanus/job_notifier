module JobNotifier
  module Identifier
    extend ActiveSupport::Concern

    included do
      def job_identifier
        identifier = if self.class.job_identifier_proc
                       self.class.job_identifier_proc.call(self).to_s
                     else
                       identifier_from_attrs
                     end

        Digest::MD5.hexdigest(identifier)
      end
    end

    def identifier_from_attrs
      keys = self.class.identifier_attrs
      raise JobNotifier::Error::MissingAttributes.new if keys.blank?

      keys.sort.map do |attribute|
        value = send(attribute)
        raise JobNotifier::Error::BlankAttribute.new(attribute) if value.blank?
        [attribute, value.to_s]
      end.flatten.join("::")
    end

    module ClassMethods
      def identify_job_through(*attrs, &block)
        if block
          @job_identifier_proc = block
        else
          @identifier_attrs = attrs
        end
      end

      def identifier_attrs
        @identifier_attrs
      end

      def job_identifier_proc
        @job_identifier_proc
      end
    end
  end
end
