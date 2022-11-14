require 'rails_helper'

RSpec.describe Report do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question) }

  it 'sends report to author of question' do
    expect(ReportMailer).to receive(:report).with(user, answer, question).and_call_original
    Report.new(answer).send_report
  end
end
