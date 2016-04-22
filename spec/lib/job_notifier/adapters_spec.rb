require "rails_helper"

RSpec.describe JobNotifier::Adapters do
  describe "#names" do
    it { expect(subject.names).to contain_exactly("notifier") }
  end

  describe "#get_adapter_path" do
    it { expect(subject.get_adapter_path("notifier").to_s).to match(
      "app/assets/javascripts/job_notifier/notifier.js") }

    it "raises error with invalid adapter" do
      expect { subject.get_adapter_path("invalid") } .to raise_error(
        JobNotifier::Error::InvalidAdapter)
    end
  end
end
