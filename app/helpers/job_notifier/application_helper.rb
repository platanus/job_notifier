module JobNotifier
  module ApplicationHelper
    def job_identifier_for(entity)
      "data-identifier=" + entity.job_identifier
    end
  end
end
