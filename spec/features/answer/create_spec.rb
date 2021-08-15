require 'rails_helper'

feature 'User can create an answer for question', "
  In order to answers
  As an authenticated user
  I'd like to be able to create an answer on the question on the question's page
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create an answer without errors' do
      fill_in 'Body', with: 'a stupid answer'
      click_on 'Give an answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'a stupid answer'
    end

    scenario 'create an answer with errors' do
      click_on 'Give an answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries create an answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Give an answer'
  end
end
