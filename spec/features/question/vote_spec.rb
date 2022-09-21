require 'rails_helper'

feature 'User can vote for the question', "
  In order to show that i like the question
  As an authenticated user
  I'd like to be able to vote for this question
" do
  given(:user_author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user_author) }

  describe 'User is not an author of the question', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'votes for the question' do
      within "#question-#{question.id}" do
        click_on 'Like'

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'votes against for the question' do
      within "#question-#{question.id}" do
        click_on 'Dislike'

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'tries to vote for question twice' do
      within "#question-#{question.id}" do
        click_on 'Dislike'
        click_on 'Dislike'

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'cancels his vote' do
      within "#question-#{question.id}" do
        click_on 'Dislike'
        click_on 'Cancel'

        within '.rating' do
          expect(page).to have_content '0'
        end
      end
    end
  end

  describe 'User is author of question tries to', js: true do
    background do
      sign_in user_author
      visit questions_path
    end

    scenario 'vote for his question' do
      expect(page).to_not have_link 'Like'
    end

    scenario 'vote against his question' do
      expect(page).to_not have_link 'Dislike'
    end

    scenario 'cancel his vote' do
      expect(page).to_not have_link 'Cancel'
    end
  end

  describe 'Unauthorized user tries to' do
    background { visit questions_path }

    scenario 'vote for the question' do
      expect(page).to_not have_link 'Like'
    end

    scenario 'vote against for the question' do
      expect(page).to_not have_link 'Dislike'
    end

    scenario 'cancel the vote' do
      expect(page).to_not have_link 'Cancel'
    end
  end
end
