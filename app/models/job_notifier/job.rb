module JobNotifier
  class Job < ActiveRecord::Base
    extend Enumerize

    STATUSES = [:pending, :finished, :failed]

    enumerize :status, in: STATUSES, default: :pending

    attr_accessor :decoded_identifier

    before_save do
      self.identifier = self.class.encode_identifier(decoded_identifier) if decoded_identifier
    end

    def self.all_by_identifier(encoded_job_identifier)
      JobNotifier::Job.where(identifier: encoded_job_identifier)
    end

    def self.encode_identifier(identifier)
      Digest::MD5.hexdigest(identifier.to_s)
    end
  end
end
