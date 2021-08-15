require 'rails_helper'

feature 'Author can delete his question', "
  In order to delete my question
  As an authenticated user
  I'd like to be able to delete my question
" do
  given(:user_author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user_author) }

  scenario 'Author can delete his question' do
    sign_in(user_author)
    visit question_path(question)
    click_on 'Delete the question'
    expect(page).to_not have_content question.title
  end

  scenario 'Not author try delete a question' do
    sign_in(user)
    visit question_path(question)
    expect(page).not_to have_content('Delete the question')
  end

  scenario 'Unauthenticated user try delete a question' do
    visit question_path(question)
    expect(page).not_to have_content('Delete the question')
  end
end
