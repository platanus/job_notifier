module JobNotifier
  module ApplicationHelper
    def job_identifier_for(entity)
      "data-identifier=#{entity.job_identifier} data-root-url=#{JobNotifier.root_url}"
    end
  end
end
