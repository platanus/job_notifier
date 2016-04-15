module JobNotifier
  class Job < ActiveRecord::Base
    extend Enumerize

    STATUSES = [:pending, :finished, :failed]

    enumerize :status, in: STATUSES, default: :pending

    attr_accessor :decoded_identifier

    before_save do
      self.identifier = self.class.encode_identifier(decoded_identifier) if decoded_identifier
    end

    def self.update_feedback(job_id, data, status)
      job = JobNotifier::Job.find_by(job_id: job_id)
      return unless job
      job.update_columns(result: data.to_s, status: status, notified: false)
    end

    def self.unnotified_by_identifier!(encoded_identifier)
      jobs = JobNotifier::Job.where(identifier: encoded_identifier).where(notified: false)
      job_ids = jobs.ids
      jobs.update_all(notified: true)
      where(id: job_ids)
    end

    def self.encode_identifier(identifier)
      Digest::MD5.hexdigest(identifier.to_s)
    end
  end
end
