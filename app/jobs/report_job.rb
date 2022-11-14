class ReportJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Report.new(answer).send_report
  end
end
