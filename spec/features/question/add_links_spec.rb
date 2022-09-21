require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/zdvbind/a014b25d493bba679e7c8dfbb4854d77' }
  given(:yandex_url) { 'https://ya.ru/' }
  given(:bad_url) { 'blabla,ru' }

  background do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
  end

  scenario 'User can add valid links when asks question', js: true do
    click_on 'add link'
    click_on 'add link'

    page.all(:fillable_field, 'Link name')[0].set('My gist')
    page.all(:fillable_field, 'Url')[0].set(gist_url)
    page.all(:fillable_field, 'Link name')[1].set('Yandex')
    page.all(:fillable_field, 'Url')[1].set(yandex_url)
    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
    expect(page).to have_link 'Yandex', href: yandex_url
  end

  scenario 'User tries to add invalid link when asks question', js: true do
    click_on 'add link'
    fill_in 'Link name', with: 'Bad link'
    fill_in 'Url', with: bad_url
    click_on 'Ask'

    expect(page).to have_content 'Links url is not a valid URL'
  end
end
