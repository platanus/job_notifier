module JobNotifier
  module Identifier
    extend ActiveSupport::Concern

    included do
      def job_identifier
        keys = self.class.identifier_attrs
        raise JobNotifier::Error::MissingAttributes.new if keys.blank?

        identifier = keys.sort.map do |attribute|
          value = send(attribute)
          raise JobNotifier::Error::BlankAttribute.new(attribute) if value.blank?
          [attribute, value.to_s]
        end.flatten.join("::")

        Digest::MD5.hexdigest(identifier)
      end
    end

    module ClassMethods
      def indentify_by(*attrs)
        @identifier_attrs = attrs
      end

      def identifier_attrs
        @identifier_attrs
      end
    end
  end
end
