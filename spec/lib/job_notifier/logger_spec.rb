require "rails_helper"

RSpec.describe JobNotifier::Logger do
  describe "#call" do
    let(:status) { 200 }
    let(:result) do
      [
        [
          { "status" => "pending" },
          { "status" => "pending" },
          { "status" => "finished" },
          { "status" => "failed" }
        ].to_json.to_s
      ]
    end
    let(:response) { [status, nil, result] }

    let(:env) { { "PATH_INFO" => "/job_notifier/XXX/jobs/pending.json" } }
    let(:app) { double(:app, call: response) }

    let(:logger) { described_class.new(app) }

    before { allow(DateTime).to receive(:now).and_return("1984-06-04 10:00:00".to_datetime) }

    RSpec.shared_examples "invalid candidate for logging" do
      it "does not write log info" do
        allow(logger).to receive(:log_jobs_info)
        logger.call(env)
        expect(logger).not_to have_received(:log_jobs_info)
      end

      it { expect(logger.call(env)).to eq(response) }
    end

    RSpec.shared_examples "invalid request result" do
      it "calls logger with result" do
        allow(logger).to receive(:log_jobs_info)
        logger.call(env)
        expect(logger).to have_received(:log_jobs_info).with(result)
      end

      it "does not build log msg" do
        allow(logger).to receive(:build_log_msg)
        logger.call(env)
        expect(logger).not_to have_received(:build_log_msg)
      end

      it { expect(logger.call(env)).to eq(response) }
    end

    context "with other than 200 status" do
      let(:status) { 500 }
      it_behaves_like("invalid candidate for logging")
    end

    context "with invalid path info" do
      let(:env) { { "PATH_INFO" => "/invalid/path" }  }
      it_behaves_like("invalid candidate for logging")
    end

    context "with blank result" do
      let(:result) { [""] }
      it_behaves_like("invalid request result")
    end

    context "with empty array result" do
      let(:result) { ["[]"] }
      it_behaves_like("invalid request result")
    end

    it "prints log" do
      out = "\e[0;94;49m[1984-06-04 10:00:00] JOBS\e[0m  \e[0;33;49mPending: 2\e[0m  \
\e[0;32;49mFinished: 1\e[0m  \e[0;31;49mFailed: 1\e[0m\n"
      expect { logger.call(env) }.to output(out).to_stdout
    end

    it { expect(logger.call(env)).to eq(response) }
  end
end
