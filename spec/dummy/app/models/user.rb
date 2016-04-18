class User
  include JobNotifier::Identifier

  attr_accessor :id, :email

  identify_job_through :id, :email
end
