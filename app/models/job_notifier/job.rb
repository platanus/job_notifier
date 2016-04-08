module JobNotifier
  class Job < ActiveRecord::Base
    attr_accessor :decoded_identifier

    before_save :encode_identifier

    private

    def encode_identifier
      return unless decoded_identifier
      self.identifier = Digest::MD5.hexdigest(decoded_identifier.to_s)
    end
  end
end
