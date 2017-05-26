class SeriesController < ApplicationController
  before_action :set_series, only: %i[show edit update destroy
                                      recommend_series send_recommendation
                                      unview add_rating]
  before_action :authenticate_user!, except: %i[index show add_rating]

  # GET /series
  # GET /series.json
  def index
    series = Series.includes(:user)
    @series = []
    if current_user
      series.each do |serie|
        @series << serie if serie.user.role == 'admin' ||
                            serie.user_id == current_user.id
      end
    else
      series.each do |serie|
        @series << serie if serie.user.role == 'admin'
      end
    end
  end


  def search
    @series = []
    if params[:nombre] or params[:pais] or params[:rating]
      @series = Series.search(params[:nombre] , params[:pais] , params[:rating1],params[:rating2],params[:capitulo],params[:director],params[:actor],params[:genero])
    else
      @series=[]
    end

  end


  def recommend_series; end

  def send_recommendation
    user = current_user
    to_user = params[:email]
    SeriesMailer.send_recommendation(user, to_user, @series).deliver_now
    redirect_to @series,
                flash: { success: "Se ha enviado la recomendacion a #{to_user}" }
  end

  # GET /series/1
  # GET /series/1.json
  def show
    @user = current_user
    @boole = @user && @user.series_views.include?(@series)
  end

  # GET /series/new
  def new
    @series = Series.new
  end

  # GET /series/1/edit
  def edit; end

  # POST /series
  # POST /series.json
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

  # PATCH/PUT /series/1
  # PATCH/PUT /series/1.json
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

  # DELETE /series/1
  # DELETE /series/1.json
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
    else
      user.series_views << @series
    end
    redirect_to @series
  end

  private

  def set_series
    @series = Series.find(params[:id])
  end

  def series_params
    params.require(:series).permit(:name, :description, :country, :image)
  end

  def recalcular_rating(serie)
    serie.rating = serie.ratings.average(:rating)
    serie.save
  end
end
