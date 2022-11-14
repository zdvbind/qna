class ReportMailer < ApplicationMailer
  def report(user, answer, question)
    @answer = answer
    @question = question

    mail(to: user.email, subject: 'Received a new answer')
  end
end
