require "rails_helper"

RSpec.describe JobNotifier::Notifier do
  before do
    Object.send(:remove_const, :ImageUploadJob) rescue nil
  end

  def self.expect_job_creation
    it "creates new job" do
      expect { ImageUploadJob.perform_later("id", "param1", "param2") }.to(
        change(JobNotifier::Job, :count).from(0).to(1))
    end

    it "encodes job identifier" do
      identifier = { email: "emilio@platan.us" }
      ImageUploadJob.perform_later(identifier, "param1", "param2")
      job = JobNotifier::Job.last
      expect(job.identifier).to eq(Digest::MD5.hexdigest(identifier.to_s))
    end

    it "raises error with no identifier" do
      expect { ImageUploadJob.perform_later }.to(
        raise_error(JobNotifier::Error::InvalidIdentifier))
    end
  end

  context "defining perform_with_feedback" do
    context "with success feedback" do
      before do
        class ImageUploadJob < ActiveJob::Base
          def perform_with_feedback(param1, param2)
            "photo loaded! with #{param1} and #{param2}"
          end
        end
      end

      expect_job_creation

      it "saves result" do
        ImageUploadJob.perform_later("id", "param1", "param2")
        expect(JobNotifier::Job.last.result).to eq("photo loaded! with param1 and param2")
      end

      it "sets success state" do
        ImageUploadJob.perform_later("id", "param1", "param2")
        expect(JobNotifier::Job.last.status).to eq("finished")
      end
    end

    context "with error feedback" do
      before do
        class ImageUploadJob < ActiveJob::Base
          def perform_with_feedback(param1, param2)
            raise JobNotifier::Error::Validation.new(error: "invalid photo url")
          end
        end
      end

      expect_job_creation

      it "saves error" do
        ImageUploadJob.perform_later("id", "param1", "param2")
        expect(JobNotifier::Job.last.result).to eq("{:error=>\"invalid photo url\"}")
      end

      it "sets error state" do
        ImageUploadJob.perform_later("id", "param1", "param2")
        expect(JobNotifier::Job.last.status).to eq("failed")
      end
    end

    context "with unexpected error" do
      before do
        class ImageUploadJob < ActiveJob::Base
          def perform_with_feedback(param1, param2)
            raise "unexpected error"
          end
        end
      end

      it "creates new job but throw the exception" do
        expect { ImageUploadJob.perform_later("id", "param1", "param2") }.to(
          raise_error(RuntimeError, "unexpected error"))
        expect(JobNotifier::Job.count).to eq(1)
        job = JobNotifier::Job.last
        expect(job.result).to eq("unknown")
        expect(job.status).to eq("failed")
      end
    end
  end

  context "without defining perform_with_feedback" do
    before do
      class ImageUploadJob < ActiveJob::Base
      end
    end
  end
end
