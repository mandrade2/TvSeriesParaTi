class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_user, only: %i[children new_child
                                       create_child destroy_child]

  def user_profile; end

  def other_user_profile
    @user = User.find(params[:username])
  end

  def index
    return redirect_to root_path unless current_user.admin?
    @users = User.all
    return @users unless params[:search_for].present?
    search_text = params[:search_text].strip if params[:search_text]
    @users = if params[:search_for] == 'email'
               @users.email_like(search_text)
             elsif params[:search_for] == 'name'
               @users.name_like(search_text)
             else
               @users.username_like(search_text)
             end
    if @users.empty?
      flash[:info] = 'Busqueda sin resultados, recuerda
                      que las mayúsculas importan'
    end
  end

  def search
    redirect_to users_path
  end

  def upgrade
    user = User.find(params[:user_id])
    user.upgrade_to_admin
    if user.admin?
      flash[:success] = "Usuario #{user.username} fue ascendido correctamente"
    else
      flash[:warning] = "Usuario #{user.username} no fue ascendido"
    end
    redirect_to users_path
  end

  def children
    @children = current_user.children
    flash[:info] = 'Busqueda sin resultados' if @children.empty?
  end

  def new_child
    if current_user.children.count >= 5
      flash[:warning] = 'No puede agregar mas cuentas hijo'
      redirect_to children_path
    end
    @child = User.new
  end

  def create_child
    @child = User.new(children_params)
    @child.role = 'child'
    if @child.skip_confirmation! && @child.save
      current_user.children << @child
      redirect_to children_path,
                  flash: { success: 'Cuenta hijo creada con exito' }
    else
      flash[:warning] = 'Cuenta no a podido ser creada'
      render 'new_children'
    end
  end

  def destroy_child
    @child = User.find(params[:child_id])
    @child.destroy
    flash[:success] = 'Cuenta hijo fue borrada correctamente'
    redirect_to children_path
  end

  def destroy
    @user = User.find(params[:user_id])
    @user.destroy
    flash[:success] = 'Usuario fue borrado correctamente'
    redirect_to users_path
  end

  private

  def children_params
    params.require(:user).permit(:name, :username, :email,
                                 :password, :password_confirmation)
  end

  def verify_user
    redirect_to root_path unless current_user.user? || current_user.admin?
  end
end
