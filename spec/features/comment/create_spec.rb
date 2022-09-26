require 'rails_helper'

feature 'User can leave a comment for the question or the answer', "
  In order to leave a comment for the question or answer
  As an authenticated user
  I'd like to be able to create the comment
" do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticate user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    describe 'leaves a comment for a question' do
      scenario 'without an errors' do
        within '.question-comments' do
          fill_in 'comment_body', with: 'My very helpful comment for a question'

          click_on 'Leave a comment'
          expect(page).to have_content 'My very helpful comment for a question'
        end
      end

      scenario 'with an errors' do
        within '.question-comments' do

          click_on 'Leave a comment'
          expect(page).to have_content "Body can't be blank"
        end
      end
    end

    describe 'leaves a comment for an answer' do
      scenario 'without an errors' do
        within '.answer-comments' do
          fill_in 'comment_body', with: 'My very helpful comment for an answer'

          click_on 'Leave a comment'
          expect(page).to have_content 'My very helpful comment for an answer'
        end
      end

      scenario 'with an errors' do
        within '.answer-comments' do

          click_on 'Leave a comment'
          expect(page).to have_content "Body can't be blank"
        end
      end
    end
  end

  scenario 'An authenticated user can not leave a comment for resource', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Leave a comment'
  end
end
