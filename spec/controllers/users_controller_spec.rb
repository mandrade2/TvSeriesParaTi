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

    it "should let a user see all the posts" do
      user = create(:user)
      user.role = 'admin'
      login_with user
      get :index
      expect(response).to render_template('users/index')
    end
  end
end
