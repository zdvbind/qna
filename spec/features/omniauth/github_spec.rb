require 'rails_helper'

feature 'Authorization from Github', "
  As an unauthenticated user
  I'd like to be able to sing_in with Github
" do
  background do
    visit root_path
    click_on 'Sign in'
  end

  scenario 'Correct login' do
    expect(page).to have_link 'Sign in with GitHub'

    mock_auth_hash(:github, 'new@user.com')

    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Successfully authenticated from github account.'
  end

  scenario 'Incorrect login' do
    expect(page).to have_link 'Sign in with GitHub'

    invalid_mock_auth_hash(:github)

    click_on 'Sign in with GitHub'

    expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials".'
  end
end
