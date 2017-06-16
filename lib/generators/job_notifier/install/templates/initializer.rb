JobNotifier.setup do |config|
  # If you're using an app client that is not part of rails project where Job Notifier gem was
  #  installed, you can define a custom root_url. For example: "http://app.platan.us/"
  # config.root_url = "/"

  # This gem uses the polling technique to inform what's happening with your jobs. This generates
  #  a noisy log output. If you want to silence this output
  # config.silenced_log = false
end
