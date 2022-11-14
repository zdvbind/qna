require 'rails_helper'

RSpec.describe ReportMailer, type: :mailer do
  describe 'report' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:answer) { create(:answer) }
    let(:mail) { ReportMailer.report(user, answer, question) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Received a new answer')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
