require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'anonymous user' do
    before :each do
      # This simulates an anonymous user
      login_with nil
    end

    it 'should be redirected to sign in' do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'admin should see users list' do
      user = create(:user)
      user.role = 'admin'
      login_with user
      get :index
      expect(response).to render_template('users/index')
    end

    it 'user should see his child account list' do
      user = create(:user)
      login_with user
      get :children, params: { username: user.username }
      expect(response).to render_template('users/children')
    end
  end
end
