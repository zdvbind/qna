require 'rails_helper'

feature 'Author of question can choose the best answer', "
  In order to choose an answer as the best
  As an question author
  I'd like to be able to choose the best answer
" do
  given(:user) { create(:user) }
  given(:author_of_answer) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer1) { create(:answer, question: question, author: author_of_answer, body: 'answer1') }
  given!(:answer2) { create(:answer, question: question, author: author_of_answer, body: 'answer2') }

  describe 'Unauthenticated user' do
    scenario "can't choose the best answer" do
      visit question_path(question)
      expect(page).to_not have_link 'Choose'
    end
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(question.author)
      visit question_path(question)
      within("#answer-#{answer1.id}") do
        click_on 'Choose'
      end
    end

    scenario 'can choose the best answer for his question' do
      within('.best-answer') do
        expect(page).to have_content 'The best answer:'
        expect(page).to have_content 'answer1'
        expect(page).to_not have_link 'Choose'
      end
    end

    scenario 'can change the best answer for his question' do
      click_on('Choose')

      within '.best-answer' do
        expect(page).to have_content 'The best answer'
        expect(page).to have_content 'answer2'
        expect(page).to_not have_link 'Choose'
      end

      within '.other-answers' do
        expect(page).to_not have_content 'answer2'
        expect(page).to have_content 'answer1'
        expect(page).to have_link 'Choose'
      end
    end
  end

  scenario "Authenticated user can't choose the best answer for someone else's question" do
    sign_in(author_of_answer)
    visit question_path(question)
    expect(page).to_not have_link 'Choose'
  end
end
