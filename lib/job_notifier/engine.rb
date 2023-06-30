module JobNotifier
  class Engine < ::Rails::Engine
    isolate_namespace JobNotifier

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    config.serve_static_files = true

    initializer "initialize" do
      require_relative "./error"
      require_relative "./notifier"
      require_relative "./identifier"
      require_relative "./adapters"
      require_relative "./logger"

      if JobNotifier.silenced_log
        Rails.application.middleware.swap(
          Rails::Rack::Logger,
          Silencer::Logger,
          silence: [%r{\/job_notifier\/\w+\/jobs\/\w+.json}]
        )

        Rails.application.middleware.insert_before(Silencer::Logger, JobNotifier::Logger)
      end
    end
  end
end
