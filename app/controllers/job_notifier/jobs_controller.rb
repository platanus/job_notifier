module JobNotifier
  class JobsController < ActionController::Base
    def index
      jobs = Job.all_by_identifier(params[:identifier])
      render json: jobs
    end
  end
end
