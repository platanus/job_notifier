require "rails_helper"

module JobNotifier
  RSpec.describe Job, type: :model do
    it { is_expected.to enumerize(:status).in(:pending, :finished, :failed) }

    describe "#unnotified_by_identifier" do
      subject { JobNotifier::Job }
      let!(:job1) { create(:job_notifier_job, identifier: "jcm14n", notified: false) }
      let!(:job2) { create(:job_notifier_job, identifier: "otro", notified: false) }
      let!(:job3) { create(:job_notifier_job, identifier: "jcm14n", notified: true) }
      before { @jobs = subject.unnotified_by_identifier(job1.identifier) }

      it "returns unnotified for given identifier only" do
        expect(@jobs.count).to eq(1)
        expect(@jobs.first.id).to eq(job1.id)
        expect(@jobs.first.notified).to be_falsey
      end

      it "ignores jobs with not requested identifier" do
        expect(Job.find(job2.id).notified).to be_falsey
      end

      it "ignores notified jobs" do
        job = Job.find(job3.id)
        expect(job.notified).to be_truthy
        expect(job.identifier).to eq(job1.identifier)
      end
    end

    describe "#notify_by_identifier" do
      subject { JobNotifier::Job }
      let!(:job1) { create(:job_notifier_job, identifier: "jcm14n", notified: false) }
      let!(:job2) { create(:job_notifier_job, identifier: "otro", notified: false) }
      before { subject.notify_by_identifier(job1.identifier) }

      it "notifies unnotified for given identifier only" do
        expect(job1.reload.notified).to be_truthy
      end

      it "ignores jobs with not requested identifier" do
        expect(Job.find(job2.id).notified).to be_falsey
      end
    end

    describe "#update_feedback" do
      subject { JobNotifier::Job }
      let!(:job) { create(:job_notifier_job, notified: true, job_id: "hd70oj") }
      before { subject.update_feedback(job.job_id, "success", :finished) }

      it { expect(job.reload.status).to eq("finished") }
      it { expect(job.reload.notified).to be_falsey }
      it { expect(job.reload.result).to eq("success") }
    end
  end
end
