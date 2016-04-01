$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem"s version:
require "job_notifier/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "job_notifier"
  s.version     = JobNotifier::VERSION
  s.authors     = ["Leandro Segovia"]
  s.email       = ["ldlsegovia@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of JobNotifier."
  s.description = "TODO: Description of JobNotifier."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2.5.2"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "~> 3.4.0"
  s.add_development_dependency "factory_girl_rails", "~> 4.6.0"
end
