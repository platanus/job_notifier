$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem"s version:
require "job_notifier/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "job_notifier"
  s.version     = JobNotifier::VERSION
  s.authors     = ["Platanus", "Emilio Blanco", "Leandro Segovia"]
  s.email       = ["rubygems@platan.us", "emilioeduardob@gmail.com", "ldlsegovia@gmail.com"]
  s.homepage    = "https://github.com/platanus/job_notifier"
  s.summary     = "Rails engine to persist job results and notify job status changes"
  s.description = "Rails engine built on top on Active Job gem to persist job results and notify job status changes"
  s.license     = "MIT"

  s.files = `git ls-files`.split($/).reject { |fn| fn.start_with? "spec" }
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ">= 6.0"

  s.add_dependency "colorize", ">= 0.7.7"
  s.add_dependency "enumerize", ">= 1.0"
  s.add_dependency "silencer", "1.0.0.rc3"

  s.add_development_dependency "coveralls"
  s.add_development_dependency "factory_bot_rails"
  s.add_development_dependency "pry"
  s.add_development_dependency "rspec_junit_formatter"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rubocop", "~> 1.9"
  s.add_development_dependency "rubocop-rails"
  s.add_development_dependency "sqlite3"
end
