require 'rails_helper'

feature 'User can watch a list of questions', "
  In order to find a question
  As an user
  I'd like to be able to watch a list of all the questions
" do
  given!(:questions) { create_list(:question, 4) }


  scenario 'User tries to watch a list of questions' do
    visit questions_path

    questions.each { |question| expect(page).to have_content(question.title)}
  end
end