module JobNotifier
  class Logger
    def initialize(app)
      @app = app
    end

    def call(env)
      response = @app.call(env)
      status = response[0]
      return response if status != 200
      log_jobs_info(response[2]) if env["PATH_INFO"] =~ %r{\/\w+\/jobs\/\w+.json}
      response
    end

    private

    def log_jobs_info(response)
      response.each do |resp|
        next if resp.blank?
        result = JSON.parse(resp)
        result = result["jobs"] if result.is_a?(Hash)
        next if result.blank?
        puts build_log_msg(result)
      end
    end

    def build_log_msg(result)
      msg = ["[#{DateTime.now.strftime('%Y-%m-%d %H:%M:%S')}] JOBS".light_blue]
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
