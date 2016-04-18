class HomeController < ApplicationController
  def index
    @current_user = User.new
    @current_user.id = 1
    @current_user.email = "emilio@platan.us"

    JobNotifier::Job.find_or_create_by(identifier: @current_user.job_identifier)
  end
end
