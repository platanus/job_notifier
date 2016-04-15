module JobNotifier
  module Notifier
    extend ActiveSupport::Concern

    included do
      attr_accessor :job_identifier

      def perform(*args)
        self.job_identifier = args.shift
        result = perform_with_feedback(*args)
        save_success_feedback(result)
      rescue JobNotifier::Error::Validation => ex
        save_error_feedback(ex.error)
      rescue StandardError => ex
        save_error_feedback("unknown")
        raise ex
      end

      def save_error_feedback(error)
        JobNotifier::Job.update_feedback(job_id, error, :failed)
      end

      def save_success_feedback(data)
        JobNotifier::Job.update_feedback(job_id, data, :finished)
      end

      before_enqueue do |job|
        if job.respond_to?(:perform_with_feedback)
          identifier = job.arguments.first
          raise JobNotifier::Error::InvalidIdentifier if identifier.blank?
          JobNotifier::Job.create!(decoded_identifier: identifier, job_id: job.job_id)
        end
      end
    end
  end
end

ActiveJob::Base.include(JobNotifier::Notifier)
