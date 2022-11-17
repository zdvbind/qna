require 'sphinx_helper'

feature 'User can find', "
  In order to find a necessary information
  As a user
  I'd like to be able to finding records by keywords
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, author: user) }
  given!(:comment) { create(:comment, user: user) }
  background { visit root_path }

  scenario 'User finds the question', sphinx: true do
    ThinkingSphinx::Test.run do
      sleep(0.5)
      within '.search' do
        fill_in :request, with: question.body
        select :Questions, from: :type
        click_on 'Search'
      end
      expect(page).to have_content 'Question:'
      expect(page).to have_content question.body
    end
  end

  scenario 'User finds the answer', sphinx: true do
    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in :request, with: answer.body
        select :Answers, from: :type
        click_on 'Search'
      end
      expect(page).to have_content 'Answer:'
      expect(page).to have_content answer.body
    end
  end

  scenario 'User finds the comment', sphinx: true do
    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in :request, with: comment.body
        select :Comments, from: :type
        click_on 'Search'
      end
      expect(page).to have_content 'Comment:'
      expect(page).to have_content comment.body
    end
  end

  scenario 'User finds the user', sphinx: true do
    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in :request, with: user.email
        select :Users, from: :type

        click_on 'Search'
      end
      expect(page).to have_content 'User:'
      expect(page).to have_content user.email
    end
  end

  scenario 'User find all', sphinx: true do
    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in :request, with: user.email
        click_on 'Search'
      end
      expect(page).to have_content 'User:'
      expect(page).to have_content user.email
      expect(page).to have_content 'Question:'
      expect(page).to have_content question.body
      expect(page).to have_content 'Comment:'
      expect(page).to have_content comment.body
      expect(page).to have_content 'Answer:'
      expect(page).to have_content answer.body
    end
  end
end
