module JobNotifier
  class Logger < Rails::Rack::Logger
    def initialize(app, opts = {})
      @app = app
      @opts = opts
      super
    end

    def call(env)
      if env["PATH_INFO"] =~ %r{\/job_notifier\/\w+\/jobs\/\w+.json}
        Rails.logger.silence do
          response = @app.call(env)
          log_jobs_info(response[2])
          return response
        end
      end

      super(env)
    end

    def log_jobs_info(response)
      response.each do |resp|
        next if resp.blank?
        result = JSON.parse(resp)
        next if result.blank?
        puts build_log_msg(result)
      end
    end

    def build_log_msg(result)
      msg = ["[#{DateTime.now.strftime('%Y-%m-%d %H:%M:%S')}] UNNOTIFIED JOBS".light_blue]
      grouped_jobs = result.group_by { |job| job["status"].to_sym }
      load_job_status_msg(grouped_jobs, msg, :pending, :yellow)
      load_job_status_msg(grouped_jobs, msg, :finished, :green)
      load_job_status_msg(grouped_jobs, msg, :failed, :red)
      msg.join("  ")
    end

    def load_job_status_msg(grouped_jobs, msg, status, color)
      if grouped_jobs.has_key?(status)
        msg << "#{status.to_s.capitalize}: #{grouped_jobs[status].count}".send(color)
      end
    end
  end
end
