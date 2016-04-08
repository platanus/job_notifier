module JobNotifier
  class Engine < ::Rails::Engine
    isolate_namespace JobNotifier

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    initializer "initialize" do
      require_relative "./error"
      require_relative "./notifier"
    end
  end
end
