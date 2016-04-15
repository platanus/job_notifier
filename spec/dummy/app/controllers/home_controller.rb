class HomeController < ApplicationController
  def index
    @identifier = JobNotifier::Job.encode_identifier("email: emilio@platan.us")
    JobNotifier::Job.find_or_create_by identifier: @identifier
  end
end
