class UsersController < ApplicationController
  before_action :authenticate_user!

  def profile; end

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

  def new_children
    if current_user.children.count >= 5
      flash[:warning] = 'No puede agregar mas cuentas hijo'
      redirect_to children_path
    end
    @child = User.new
  end

  def create_children
    @child = User.new(children_params)
    @child.role = 'child'
    @child.skip_confirmation!
    respond_to do |format|
      if @child.save
        current_user.children << @child
        flash[:success] = 'Cuenta hijo creada con exito'
        format.html { redirect_to children_path }
      else
        flash[:warning] = 'Cuenta no a podido ser creada'
        format.html { render 'new_children' }
      end
    end
  end

  def destroy_children
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
end
