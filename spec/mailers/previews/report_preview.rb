# Preview all emails at http://localhost:3000/rails/mailers/report
class ReportPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/report/report
  def report
    ReportMailer.report(User.first, Question.first.answers.first, Question.first)
  end
end
