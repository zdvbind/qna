require 'rails_helper'

feature 'User can subscribe on the question', "
    In order to get report about new answers
    As an authenticated user
    I would like to able to subscribe on the question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    scenario 'can subscribe' do
      sign_in(user)
      visit question_path(question)

      within('.subscription') do
        expect(page).to_not have_content 'Unsubscribe'
        expect(page).to have_content 'Subscribe'

        click_on 'Subscribe'

        expect(page).to have_content 'Unsubscribe'
        expect(page).to_not have_content 'Subscribe'
      end
    end
  end

  describe 'Guest', js: true do
    scenario 'can not subscribe or unsubscribe' do
      visit question_path(question)
      expect(page).to_not have_content 'Subscribe'
      expect(page).to_not have_content 'Unsubscribe'
    end
  end
end
