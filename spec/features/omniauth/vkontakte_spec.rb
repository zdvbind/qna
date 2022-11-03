require 'rails_helper'

feature 'Authorization from Vkontakte', "
  As an unauthenticated user
  I'd like to be able to sing_in with Vkontakte
" do
  background do
    visit root_path
    click_on 'Sign in'
  end

  scenario 'Correct login' do
    expect(page).to have_link 'Sign in with Vkontakte'

    mock_auth_hash(:vk)

    click_on 'Sign in with Vkontakte'

    fill_in 'Email', with: 'new@user.com'
    click_on 'Continue'

    visit root_path
    click_on 'Sign in'

    click_on 'Sign in with Vkontakte'
    expect(page).not_to have_content 'Successfully authenticated from vkontakte account.'

    open_email('new@user.com')
    current_email.click_link 'Confirm my account'

    click_on 'Sign in'
    click_on 'Sign in with Vkontakte'
    expect(page).to have_content 'Successfully authenticated from vkontakte account.'
  end

  scenario 'Incorrect login' do
    expect(page).to have_link 'Sign in with Vkontakte'

    invalid_mock_auth_hash(:vk)

    click_on 'Sign in with Vkontakte'

    expect(page).to_not have_content 'Successfully authenticated from vkontakte account.'
  end
end
