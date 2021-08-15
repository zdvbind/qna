require 'rails_helper'

feature 'User can see the question and answers for it', "
  In order to help with an answer on a question
  As an user
  I'd like to be able to see answers for questions and it's question
" do
  describe 'User' do
    given(:user) { create(:user) }
    given(:question) { create(:question, author: user) }
    given!(:answers) { create_list(:answer, 3, question: question, author: user) }

    scenario 'view the question' do
      visit question_path(question)
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'view the answers on the question' do
      visit question_path(question)
      answers.each { |answer| expect(page).to have_content answer.body }
    end
  end
end
