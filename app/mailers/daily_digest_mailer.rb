class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where(created_at: (Time.zone.now - 1.day)..Time.zone.now)

    mail to: user.email
  end
end
