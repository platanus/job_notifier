module JobNotifier
  class Job < ActiveRecord::Base
    attr_accessor :decoded_identifier

    before_save do
      self.identifier = self.class.encode_identifier(decoded_identifier) if decoded_identifier
    end

    def self.job_by_identifier(decoded_identifier)
      encoded_job_identifier = encode_identifier(decoded_identifier)
      JobNotifier::Job.where(identifier: encoded_job_identifier).first
    end

    def self.encode_identifier(identifier)
      Digest::MD5.hexdigest(identifier.to_s)
    end
  end
end
