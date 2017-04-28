class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    return redirect_to root_path unless current_user.admin?
    @users = User.all
    return @users unless params[:search_for].present?
    @users = if params[:search_for] == 'email'
               @users.email_like(params[:search_text])
             elsif params[:search_for] == 'name'
               @users.name_like(params[:search_text])
             else
               @users.username_like(params[:search_text])
             end
    if @users.empty?
      flash[:notice] = 'Busqueda sin resultados'
    end
  end

  def search
    redirect_to users_path
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.noticiums.paginate(page: params[:page])
  end

  def destroy
    @user = User.find(params[:user_id])
    @user.destroy
    redirect_to users_path
  end
end
