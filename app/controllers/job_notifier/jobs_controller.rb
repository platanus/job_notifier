module JobNotifier
  class JobsController < ActionController::Base
    skip_before_action :verify_authenticity_token

    def index
      render json: Job.unnotified_by_identifier(params[:identifier])
    end

    def update
      Job.notify_by_identifier(params[:identifier])
      head :no_content
    end
  end
end
