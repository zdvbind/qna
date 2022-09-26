require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given(:not_author) { create(:user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario "Authenticated user tries to edit other user's question" do
    sign_in(not_author)
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in user
      visit question_path(question)
      within '.answers' do
        click_on 'Edit'
      end
    end

    scenario 'edits his answer without errors' do
      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector :id, 'answer_body'
      end
    end

    scenario 'edits his answer with errors' do
      within '.answers' do
        fill_in 'Your answer', with: nil
        click_on 'Save'

        expect(page).to have_content answer.body
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'edits his answer and add files' do
      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his answer and add links' do
      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Add link'
        fill_in 'Link name', with: 'Yandex'
        fill_in 'Url', with: 'https://ya.ru'
        click_on 'Save'

        expect(page).to have_link 'Yandex', href: 'https://ya.ru'
      end
    end
  end
end
