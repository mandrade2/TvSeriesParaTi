require 'rails_helper'

RSpec.feature 'SearchUsers', type: :feature do
  # it 'should require the user log in as admin before searching a user' do
  #   password = '123456789'
  #   user = create(:user, password: password, password_confirmation: password)
  #   visit new_user_session_path
  #   within '#new_user' do
  #     fill_in 'user_email', with: user.email
  #     fill_in 'user_password', with: password
  #   end
  #
  #   click_button 'Log in'
  #
  #   visit users_path
  #   searched_user = create(:user)
  #   fill_in name: 'search_text', with: searched_user.username
  # end
end
