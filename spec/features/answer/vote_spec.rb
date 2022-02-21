require 'rails_helper'

feature 'User can vote for the answer', "
  In order to show that i like the answer
  As an authenticated user
  I'd like to be able to vote for this answer
" do
  given(:user_author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user_author) }

  describe 'User is not an author of the answer', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'votes for the answer' do
      within "#answer-#{answer.id}" do
        click_on 'Like'

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'votes against for the answer' do
      within "#answer-#{answer.id}" do
        click_on 'Dislike'

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'tries to vote for answer twice' do
      within "#answer-#{answer.id}" do
        click_on 'Dislike'
        click_on 'Dislike'

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'cancels his vote' do
      within "#answer-#{answer.id}" do
        click_on 'Dislike'
        click_on 'Cancel the vote'

        within '.rating' do
          expect(page).to have_content '0'
        end
      end
    end
  end

  describe 'User is author of answer tries to', js: true do
    background do
      sign_in user_author
      visit questions_path
    end

    scenario 'vote for his answer' do
      expect(page).to_not have_link 'Like'
    end

    scenario 'vote against his answer' do
      expect(page).to_not have_link 'Dislike'
    end

    scenario 'cancel his vote' do
      expect(page).to_not have_link 'Cancel the vote'
    end
  end

  describe 'Unauthorized user tries to' do
    background { visit questions_path }

    scenario 'vote for the answer' do
      expect(page).to_not have_link 'Like'
    end

    scenario 'vote against the answer' do
      expect(page).to_not have_link 'Dislike'
    end

    scenario 'cancel his vote' do
      expect(page).to_not have_link 'Cancel the vote'
    end
  end
end
