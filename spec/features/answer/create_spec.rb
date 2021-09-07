require 'rails_helper'

feature 'User can create an answer for question', "
  In order to answers
  As an authenticated user
  I'd like to be able to create an answer on the question on the question's page
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create an answer without errors' do
      fill_in 'Body', with: 'a stupid answer'
      click_on 'Give an answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do # чтобы убедиться, что ответ в списке, а не в форме
        expect(page).to have_content 'a stupid answer'
      end
    end

    scenario 'create an answer with errors' do
      click_on 'Give an answer'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'create an answer with attached file' do
      fill_in 'Body', with: 'a stupid answer'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Give an answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries create an answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Give an answer'
  end
end
