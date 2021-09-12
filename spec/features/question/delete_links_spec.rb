require 'rails_helper'

feature 'User can delete links from the question', "
  In order to provide additional info to my question
  As a question's author
  I'd like to be able to delete links
" do
  given(:author) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) { create(:question, author: author) }
  given!(:yandex) { create(:link, linkable: question, name: 'yandex', url: 'http://ya.ru') }

  describe 'Authenticated user', js: true do
    scenario 'delete link from his question' do
      sign_in(author)
      visit question_path(question)
      expect(page).to have_link 'yandex', href: 'http://ya.ru'
      click_on 'Delete the link'
      expect(page).to_not have_link 'yandex'
    end


    scenario "tries to delete other user's questions's link" do
      sign_in(not_author)
      visit question_path(question)
      expect(page).to_not have_link 'Delete the link'
    end
  end

  scenario 'Unauthenticated user can not delete the link' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete the link'
  end
end