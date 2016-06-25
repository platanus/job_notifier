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

    def self.unnotified_by_identifier(encoded_identifier)
      JobNotifier::Job.where(identifier: encoded_identifier).where(notified: false)
    end

    def self.notify_by_identifier(encoded_identifier)
      unnotified_by_identifier(encoded_identifier).update_all(notified: true)
    end
  end
end
