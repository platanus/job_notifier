module JobNotifier
  module Notifier
    extend ActiveSupport::Concern

    included do
      attr_accessor :job_key

      def perform
      end

      before_enqueue do |job|
        identifier = job.arguments.shift
        raise JobNotifier::Error::InvalidIdentifier if identifier.blank?
        JobNotifier::Job.create!(decoded_identifier: identifier)
      end
    end
  end
end

ActiveJob::Base.include(JobNotifier::Notifier)
