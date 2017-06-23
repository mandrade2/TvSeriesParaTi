class SeriesController < ApplicationController
  before_action :set_series, only: %i[show edit update destroy
                                      recommend_series send_recommendation
                                      unview add_rating comment
                                      delete_comment toggle_spoiler ]
  before_action :authenticate_user!, except: %i[index show search]

  # GET /series
  # GET /series.json
  def index
    @series = Series.get_series_by_role(current_user).includes(:user)
  end

  def search
    @series = []
    if params[:nombre] || params[:pais] || params[:rating1] ||
       params[:rating2] || params[:capitulo] || params[:director] ||
       params[:actor] || params[:genero]
      @series = Series.search(current_user, params[:nombre], params[:pais],
                              params[:rating1], params[:rating2],
                              params[:capitulo], params[:director],
                              params[:actor], params[:genero])
    end
    unless params[:rating_order].blank?
      if params[:rating_order] == '1'
        @series.sort! { |a, b| a.rating <=> b.rating }.reverse!
      elsif params[:rating_order] == '2'
        @series.sort! { |a, b| a.rating <=> b.rating }
      end
    end
    return if params[:release_date_order].blank?
    if params[:release_date_order] == '1'
      @series.sort! { |a, b| a.release_date <=> b.release_date }.reverse!
    elsif params[:release_date_order] == '2'
      @series.sort! { |a, b| a.release_date <=> b.release_date }
    end
  end

  def recommend_series; end

  def send_recommendation
    user = current_user
    to_user = params[:email]
    SeriesMailer.send_recommendation(user, to_user, @series).deliver_now
    redirect_to @series,
                flash: {
                  success: "Se ha enviado la recomendacion a #{to_user}"
                }
  end

  def comment
    content = params[:content]
    comment = Comment.new(content: content, user_id: current_user.id,
                          series_id: @series.id)
    unless comment.save
      flash[:warning] = 'No se pudo crear el comentario, debe tener contenido'
    end
    redirect_to @series
  end

  def toggle_spoiler
    comment = Comment.find(params[:comment])
    comment.spoiler = params[:is_spoiler]
    comment.save
    redirect_to @series
  end

  def delete_comment
    comment = Comment.find(params[:comment])
    comment.destroy if comment
    redirect_to @series
  end

  def show
    @user = current_user
    @comments = @series.comments
    @boole = @user && @user.series_views.include?(@series)
    if @user
      unless @series.user.admin? || @series.user_id == @user.id || @user.admin?
        redirect_to root_path,
                    flash: {
                      alert: 'No tiene permisos para acceder a esta serie'
                    }
      end
    else
      unless @series.user.role == 'admin'
        redirect_to root_path,
                    flash: {
                      alert: 'No tiene permisos para acceder a esta serie'
                    }
      end
    end
  end

  def new
    @series = Series.new
  end

  def edit; end

  def create
    @series = Series.new(series_params.merge(seasons: 0,
                                             chapters_duration: 0,
                                             rating: 0,
                                             user_id: current_user.id))

    respond_to do |format|
      if @series.save
        format.html do
          redirect_to @series,
                      flash: { success: 'Serie fue creada correctamente' }
        end
        format.json { render :show, status: :created, location: @series }
      else
        format.html { render :new }
        format.json do
          render json: @series.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @series.update(series_params)
        format.html do
          redirect_to @series,
                      flash: { success: 'Serie fue actualizada correctamente' }
        end
        format.json { render :show, status: :ok, location: @series }
      else
        format.html { render :edit }
        format.json do
          render json: @series.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @series.destroy
    respond_to do |format|
      format.html do
        redirect_to series_index_url,
                    flash: { success: 'Serie fue destruida correctamente' }
      end
      format.json { head :no_content }
    end
  end

  def add_rating
    user = current_user
    if user.series_views.include?(@series)
      actual = @series.ratings.where(user_id: user.id).first
      if actual.nil?
        SeriesRating.create(user_id: user.id,
                            series_id: @series.id, rating: params[:rating].to_i)
      else
        actual.rating = params[:rating].to_i
        actual.save
      end
      recalcular_rating(@series)
    end
    redirect_to @series
  end

  def unview
    user = current_user
    if user.series_views.include?(@series)
      user.series_views.delete(@series)
      rating = @series.ratings.where(user_id: user.id).first
      unless rating.nil?
        rating.destroy
        recalcular_rating(@series)
      end
    else
      user.series_views << @series
    end
    redirect_to @series
  end

  def new_season; end

  private

  def set_series
    @series = Series.find(params[:id])
  end

  def series_params
    params.require(:series).permit(:name, :description, :country,
                                   :release_date, :image)
  end
end
