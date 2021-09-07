require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
" do
  given!(:user_author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user_author) }

  scenario 'Unauthenticated user can not edit an answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Author' do
    background do
      sign_in(user_author)
      visit question_path(question)
      click_on 'Edit the question'
    end

    scenario 'edit his question without mistakes', js: true do
      within "#question-#{question.id}" do
        fill_in 'Title', with: 'Edited title'
        fill_in 'Your question', with: 'Edited question'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'Edited question'
        expect(page).to have_content 'Edited title'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit his question with mistakes', js: true do
      within "#question-#{question.id}" do
        fill_in 'Your question', with: nil
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'Not author' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "tries to edit other user's question", js: true do
      expect(page).to_not have_content 'Edit the question'
    end
  end
end