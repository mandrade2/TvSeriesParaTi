class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_user, only: %i[children new_child
                                       create_child destroy_child]

  def profile
    @user = User.find_by(username: params[:username])
  end

  def other_user_profile
    @user = User.find_by(username: params[:username])
  end

  def index
    return redirect_to root_path unless current_user.admin?
    @users = User.all
  end

  def search
    return redirect_to root_path unless current_user.admin?
    return @users unless params[:search_for].present?
    search_text = params[:search_text].strip if params[:search_text]
    @users = User.all
    @users = if params[:search_for] == 'email'
               @users.email_like(search_text)
             elsif params[:search_for] == 'name'
               @users.name_like(search_text)
             else
               @users.username_like(search_text)
             end
    if @users.empty?
      redirect_to users_path, flash: { info: 'Busqueda sin resultados' }
    end
    render 'index'
  end

  def upgrade
    user = User.find(params[:user_id])
    user.upgrade_to_admin
    if user.admin?
      flash.now[:success] = "Usuario #{user.username}
                            fue ascendido correctamente"
    else
      flash.now[:warning] = "Usuario #{user.username} no fue ascendido"
    end
    redirect_to users_path
  end

  def children
    @children = current_user.children
  end

  def new_child
    if current_user.children.count >= 5
      redirect_to children_path,
                  flash: { warning: 'No puede agregar mas cuentas hijo' }
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
      render 'new_child'
    end
  end

  def destroy_child
    @child = User.find(params[:child_id])
    @child.destroy
    redirect_to children_path,
                flash: { success: 'Cuenta hijo fue borrada correctamente' }
  end

  def destroy
    @user = User.find(params[:user_id])
    @user.destroy
    redirect_to users_path,
                flash: { success: 'Usuario fue borrado correctamente' }
  end

  def get_stats
    user = current_user
    @minuts_series = get_chapters_per_season(user)
    @total_minuts = get_total_minuts(user)
    @list_of_views = get_list_of_views(user)
    @views_series = get_most_view(user)
  end

  private

  def get_chapters_per_season(user)
    minuts_series = {}
    chapters_series = {}
    chapters = user.chapters_views
    chapters.each do |chapter|
      serie = chapter.season.series
      if minuts_series.key?(serie.id)
        minuts_series[serie.id][1] += chapter.duration
        chapters_series[serie.id][1] += 1
      else
        minuts_series[serie.id] = [serie.name, chapter.duration]
        chapters_series[serie.id] = [serie.name, 1]
      end
    end
    [minuts_series.values, chapters_series.values, chapters.length]
  end

  def get_total_minuts(user)
    user.chapters_views.sum(:duration)
  end

  def get_list_of_views(user)
    series = user.series_views.select(:name)
    chapters = user.chapters_views.select(:name)
    [series, chapters]
  end

  def get_most_view(user)
    series = Series.get_series_by_role(user)
    viewers_series = {}
    gender_views = {}
    series.each do |serie|
      views = serie.viewers.length
      viewers_series[serie.id] = [serie.name, views]
      serie.genders.each do |gender|
        if gender_views.key? gender.id
          gender_views[gender.id][1] += views
        else
          gender_views[gender.id] = [gender.name, views]
        end
      end
    end
    views = viewers_series.values.sort { |x| x[1] }.reverse
    views = views[0..10] if views.length > 10
    gender = gender_views.values.sort { |x| x[1] }.reverse
    [views, gender]
  end


  def children_params
    params.require(:user).permit(:name, :username, :email,
                                 :password, :password_confirmation)
  end

  def verify_user
    redirect_to root_path unless current_user.user? || current_user.admin?
  end
end
