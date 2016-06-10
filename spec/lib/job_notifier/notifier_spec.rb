require "rails_helper"

RSpec.describe JobNotifier::Notifier do
  before do
    Object.send(:remove_const, :ImageUploadJob) rescue nil
    Object.send(:remove_const, :TestUser) rescue nil

    class TestUser
      include JobNotifier::Identifier
      attr_accessor :email
      identify_job_through :email
    end

    tu = TestUser.new
    tu.email = "emilio@platan.us"
    @identifier = tu.job_identifier
  end

  def self.expect_job_creation
    it "creates new job" do
      expect { ImageUploadJob.perform_later(@identifier, "param1", "param2") }.to(
        change(JobNotifier::Job, :count).from(0).to(1))
    end

    it "raises error with no identifier" do
      expect { ImageUploadJob.perform_later }.to(
        raise_error(JobNotifier::Error::InvalidIdentifier))
    end

    context "with created job" do
      before do
        ImageUploadJob.perform_later(@identifier, "param1", "param2")
        @job = job_by_identifier(@identifier)
      end

      it { expect(@job.job_id).not_to be_nil }
      it { expect(@job.notified).to be_falsey }
      it { expect(@job.job_class).to eq("ImageUploadJob") }
    end
  end

  def job_by_identifier(identifier)
    JobNotifier::Job.where(identifier: identifier).first
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
        ImageUploadJob.perform_later(@identifier, "param1", "param2")
        expect(job_by_identifier(@identifier).result).to eq("photo loaded! with param1 and param2")
      end

      it "sets success state" do
        ImageUploadJob.perform_later(@identifier, "param1", "param2")
        expect(job_by_identifier(@identifier).status).to eq("finished")
      end
    end

    context "with error feedback" do
      before do
        class ImageUploadJob < ActiveJob::Base
          def perform_with_feedback(_param1, _param2)
            raise JobNotifier::Error::Validation.new(error: "invalid photo url")
          end
        end
      end

      expect_job_creation

      it "saves error" do
        ImageUploadJob.perform_later(@identifier, "param1", "param2")
        expect(job_by_identifier(@identifier).result).to eq("{:error=>\"invalid photo url\"}")
      end

      it "sets error state" do
        ImageUploadJob.perform_later(@identifier, "param1", "param2")
        expect(job_by_identifier(@identifier).status).to eq("failed")
      end
    end

    context "with unexpected error" do
      before do
        class ImageUploadJob < ActiveJob::Base
          def perform_with_feedback(_param1, _param2)
            raise "unexpected error"
          end
        end
      end

      it "creates new job but throw the exception" do
        expect { ImageUploadJob.perform_later(@identifier, "param1", "param2") }.to(
          raise_error(RuntimeError, "unexpected error"))
        expect(JobNotifier::Job.count).to eq(1)
        job = job_by_identifier(@identifier)
        expect(job.result).to eq("unknown")
        expect(job.status).to eq("failed")
      end
    end
  end

  context "without defining perform_with_feedback" do
    before do
      class ImageUploadJob < ActiveJob::Base
        def perform
          # work here
        end
      end
    end

    it "ignores notifier mixin" do
      expect { ImageUploadJob.perform_later }.not_to raise_error
    end
  end
end
