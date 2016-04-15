require "rails_helper"

module JobNotifier
  RSpec.describe Job, type: :model do
    it { is_expected.to enumerize(:status).in(:pending, :finished, :failed) }

    describe "#job_by_identifier" do
      subject { JobNotifier::Job }
      let!(:job) { create(:job_notifier_job, decoded_identifier: "leandro") }

      it "gets job passing valid identifier" do
        expect(subject.job_by_identifier("leandro")).to be_a(JobNotifier::Job)
      end

      it "returns nil passing unknown identifier" do
        expect(subject.job_by_identifier("unknown")).to be_nil
      end
    end
  end
end
