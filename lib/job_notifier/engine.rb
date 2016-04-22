module JobNotifier
  class Engine < ::Rails::Engine
    isolate_namespace JobNotifier

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    config.serve_static_files = true

    initializer "initialize" do
      require_relative "./error"
      require_relative "./notifier"
      require_relative "./identifier"
      require_relative "./adapters"

      ActiveSupport.on_load :action_controller do
        helper JobNotifier::ApplicationHelper
      end
    end
  end
end
