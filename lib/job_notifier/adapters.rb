module JobNotifier
  module Adapters
    def names
      dir = Engine.root.join("app", "assets", "javascripts", "job_notifier")
      files = Dir.entries(dir).select { |file| file.ends_with?(".js") }
      files.map { |file| file[0..-4] }
    end

    def get_adapter_path(adapter_name)
      raise JobNotifier::Error::InvalidAdapter.new unless names.include?(adapter_name)
      Engine.root.join("app", "assets", "javascripts", "job_notifier", "#{adapter_name}.js")
    end

    module_function :names, :get_adapter_path
  end
end
