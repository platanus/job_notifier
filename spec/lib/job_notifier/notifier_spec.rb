require "rails_helper"

RSpec.describe JobNotifier::Notifier, focus: true do
  before do
    Object.send(:remove_const, :ImageUploadJob) rescue nil
  end

  context "defining perform_with_feedback" do
    before do
      class ImageUploadJob < ActiveJob::Base
        def perform_with_feedback
        end
      end
    end

    it "creates new job" do
      expect { ImageUploadJob.perform_later("Emilio") }.to(
        change(JobNotifier::Job, :count).from(0).to(1))
    end

    it "encodes job identifier" do
      identifier = { email: "emilio@platan.us" }
      ImageUploadJob.perform_later(identifier)
      job = JobNotifier::Job.last
      expect(job.identifier).to eq(Digest::MD5.hexdigest(identifier.to_s))
    end

    it "raises error with no identifier" do
      expect { ImageUploadJob.perform_later }.to raise_error(JobNotifier::Error::InvalidIdentifier)
    end
  end
end
