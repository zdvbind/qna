require 'rails_helper'

feature 'Author can delete his question', "
  In order to delete my question
  As an authenticated user
  I'd like to be able to delete my question
" do
  given(:user_author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user_author) }
  given(:question_with_attachments) { create(:question, :with_attachments, author: user_author) }
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

  scenario 'Author can delete attachment', js: true do
    sign_in(user_author)
    visit question_path(question_with_attachments)
    click_on 'Delete the file'
    expect(page).to_not have_link 'rails_helper.rb'
  end

  scenario 'Not author try delete attachment', js: true do
    sign_in(user)
    visit question_path(question_with_attachments)

    expect(page).to have_link 'rails_helper.rb'
    expect(page).to_not have_link 'Delete the file'
  end
end
