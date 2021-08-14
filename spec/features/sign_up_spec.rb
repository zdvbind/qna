require 'rails_helper'

feature 'User can sign up', "
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign up
" do
  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to sing up' do
    fill_in 'Email', with: attributes_for(:user)[:email]
    fill_in 'Password', with: attributes_for(:user)[:password]
    fill_in 'Password confirmation', with: attributes_for(:user)[:password_confirmation]
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistered user tries to sign up with already existing email' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
