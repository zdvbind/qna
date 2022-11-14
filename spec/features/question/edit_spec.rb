require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
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
        fill_in 'Body', with: 'Edited question'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'Edited question'
        expect(page).to have_content 'Edited title'
        expect(page).to_not have_selector :id, 'question_body'
      end
    end

    scenario 'edit his question with mistakes', js: true do
      within "#question-#{question.id}" do
        fill_in 'Body', with: nil
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'edits his question and add files ', js: true do
      within "#question-#{question.id}" do
        fill_in 'Title', with: 'Edited title'
        fill_in 'Body', with: 'Edited question'
        attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his question and add link ', js: true do
      within "#question-#{question.id}" do
        fill_in 'Title', with: 'Edited title'
        fill_in 'Body', with: 'Edited question'
        click_on 'Add link'
        fill_in 'Link name', with: 'Yandex'
        fill_in 'Url', with: 'https://ya.ru'
        click_on 'Save'
        expect(page).to have_link 'Yandex', href: 'https://ya.ru'
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
