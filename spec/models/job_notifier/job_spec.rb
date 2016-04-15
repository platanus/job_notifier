require "rails_helper"

module JobNotifier
  RSpec.describe Job, type: :model do
    it { is_expected.to enumerize(:status).in(:pending, :finished, :failed) }

    describe "#all_by_identifier" do
      subject { JobNotifier::Job }
      let!(:job) { create(:job_notifier_job, decoded_identifier: "leandro") }

      it "gets job passing valid identifier" do
        expect(subject.all_by_identifier(job.identifier).first).to be_a(JobNotifier::Job)
      end

      it "returns nil passing unknown identifier" do
        expect(subject.all_by_identifier("unknown")).to be_empty
      end
    end

    describe "#update_feedback", focus: true do
      subject { JobNotifier::Job }
      let!(:job) { create(:job_notifier_job, notified: true, job_id: "hd70oj") }
      before { subject.update_feedback(job.job_id, "success", :finished) }

      it { expect(job.reload.status).to eq("finished") }
      it { expect(job.reload.notified).to be_falsey }
      it { expect(job.reload.result).to eq("success") }
    end
  end
end
