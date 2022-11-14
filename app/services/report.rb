class Report
  attr_reader :answer

  def initialize(answer)
    @answer = answer
  end

  def send_report
    question = answer.question
    question.subscriptions.find_each(batch_size: 50) do |subscription|
      ReportMailer.report(subscription.user, answer, question).deliver_later
    end
  end
end
