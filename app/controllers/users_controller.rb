class UsersController < ApplicationController
  def index
    #@users = params[:users] || User.all
    #if params[:users]
    #  @users.merge(User.new(name: 'hey'))
    #end
    @users = User.all
  end

  def search
    if %w[username name email].include?(params[:search_for])
      search_text = '%' + params[search_text] + '%'
      @users = User.where("#{params[:search_for]} like '#{search_text}'")
    else
      @users = User.all
    end
    render 'users/index'
  end

  def destroy
    @user = User.find(params[:user_id])
    @user.destroy
    redirect_to root_path
  end
end
