class ChaptersController < ApplicationController
  before_action :set_chapter, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]

  # GET /chapters
  # GET /chapters.json
  def index
    @series = Series.find(params[:series_id])
    @seasons = @series.real_seasons
  end

  # GET /chapters/1
  # GET /chapters/1.json
  def show
    @user = current_user
    @boole = @user && @user.chapters_views.include?(@chapter)
  end

  # GET /chapters/new
  def new
    @chapter = Chapter.new
    @series = Series.find(params[:series_id])
  end

  # GET /chapters/1/edit
  def edit; end

  # POST /chapters
  # POST /chapters.json
  def create
    @series = Series.find(params[:series_id])
    temporada = params[:season_number].to_i
    id_temporada = agregar_season(@series, temporada)
    p id_temporada
    @chapter = Chapter.new(chapter_params.merge(season_id: id_temporada))
    respond_to do |format|
      if @chapter.save
        actualizar_serie(@series)
        format.html do
          redirect_to series_chapter_path(@series, @chapter),
                      flash: { success: 'Capitulo fue creado correctamente' }
        end
        format.json { render :show, status: :created, location: @chapter }
      else
        evaluar_temporada(Season.find(id_temporada))
        format.html { render :new }
        format.json do
          render json: @chapter.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /chapters/1
  # PATCH/PUT /chapters/1.json
  def update
    respond_to do |format|
      if @chapter.update(chapter_params)
        actualizar_serie(@series)
        format.html do
          redirect_to series_chapter_path(@series, @chapter),
                      flash: {
                        success: 'Capitulo fue actualizado correctamente'
                      }
        end
        format.json { render :show, status: :ok, location: @chapter }
      else
        format.html { render :edit }
        format.json do
          render json: @chapter.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /chapters/1
  # DELETE /chapters/1.json
  def destroy
    temporada = @chapter.season
    @series = temporada.series
    @chapter.destroy
    evaluar_temporada(temporada)
    respond_to do |format|
      format.html do
        redirect_to series_chapters_path(@series),
                    flash: { success: 'Capitulo fue destruido correctamente' }
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
      rating = @series.ratings.where(user: user.id).first
      rating.destroy if rating
    else
      user.series_views << @series
    end
    redirect_to @series
  end

  private

  def agregar_season(serie, numero_temporada)
    temporada = serie.real_seasons.where(number: numero_temporada)
    if temporada.empty?
      temporada = Season.new(series_id: serie.id, number: numero_temporada)
      temporada.save
    else
      temporada = temporada.first
    end
    temporada.id
  end

  def evaluar_temporada(temporada)
    temporada.destroy unless temporada.nil?
  end


  def set_chapter
    @chapter = Chapter.find(params[:id])
    @series = @chapter.season.series
  end

  def chapter_params
    params.require(:chapter).permit(:name, :duration,
                                    :rating, :chapter_number)
  end
end
