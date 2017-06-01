module JobNotifier
  class AdaptersController < ActionController::Base
    skip_before_action :verify_authenticity_token, raise: false

    def show
      send_file(JobNotifier::Adapters.get_adapter_path(params[:id]))
    end
  end
end
