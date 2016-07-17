require "job_notifier/engine"
require "enumerize"
require "colorize"
require "silencer"

module JobNotifier
  extend self

  attr_writer :root_url

  def root_url
    return "/" unless @root_url
    @root_url
  end

  def setup
    yield self
    require "job_notifier"
  end
end
