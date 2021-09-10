require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/zdvbind/a014b25d493bba679e7c8dfbb4854d77' }

  scenario 'User can add links when asks answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'a stupid answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Give an answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
