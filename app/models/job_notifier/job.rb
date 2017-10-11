module JobNotifier
  class Job < ActiveRecord::Base
    extend Enumerize

    STATUSES = [:pending, :finished, :failed]

    enumerize :status, in: STATUSES, default: :pending

    def self.update_feedback(job_id, data, status)
      job = JobNotifier::Job.find_by(job_id: job_id)
      return unless job
      job.update_columns(result: data.to_s, status: status, notified: false)
    end

    def self.by_identifier(encoded_identifier)
      where(identifier: encoded_identifier)
    end
    
    def self.notified
      where(notified: true)
    end

    def self.unnotified
      where(notified: false)
    end

    def self.notify_by_identifier(encoded_identifier)
      by_identifier(encoded_identifier).unnotified.update_all(notified: true)
    end
  end
end
