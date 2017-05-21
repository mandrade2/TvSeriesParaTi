class SeriesController < ApplicationController
  before_action :set_series, only: %i[show edit update destroy]
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
    if params[:q]
      query=params[:q]
      @search = Series.search do
        fulltext query
      end
      @series=@search.results
    end
  end

  # GET /series/1
  # GET /series/1.json
  def show
    user = current_user
    @boole = user && @series.in?(user.series_views)
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
    p params
    redirect_to root_path
  end

  private

  def set_series
    @series = Series.find(params[:id])
  end

  def series_params
    params.require(:series).permit(:name, :description, :country, :image,:q)
  end

end
