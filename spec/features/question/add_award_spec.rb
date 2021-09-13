require 'rails_helper'

feature 'User can add award to question', "
  In order to reward user, who gave the best answer
  As a question's author
  I'd like to be able to add award to the question
" do
  given(:user_author) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user_author)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end

    scenario 'asks the question with an award for the best answer' do
      fill_in 'Award title', with: 'new award'
      attach_file 'Image', "#{Rails.root}/spec/files/award.png"
      click_on 'Ask'

      expect(page).to have_content 'new award'
    end
  end
end
