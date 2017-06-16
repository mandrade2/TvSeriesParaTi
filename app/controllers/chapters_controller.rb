class ChaptersController < ApplicationController
  before_action :set_chapter, only: %i[show edit update destroy
                                       unview add_rating]
  before_action :authenticate_user!, except: %i[index show search]

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

  def search
    @chapters = []
    if params[:nombre] || params[:pais] || params[:serie] ||
       params[:director] || params[:actor] || params[:genero] ||
       params[:duracion]
      @chapters = Chapter.search(params[:nombre], params[:pais], params[:serie],
                                 params[:director], params[:actor],
                                 params[:genero], params[:duracion])
    else
      @chapters = []
    end
  end

  def new
    @series = Series.find(params[:series_id])
    unless @series.user == current_user
      return redirect_to series_chapters_path(@series),
                         flash: { warning: 'Acceso no autorizado' }
    end
    @chapter = Chapter.new
  end

  def edit
    return if @series.user == current_user
    redirect_to series_chapter_path(@series, @chapter),
                flash: { warning: 'Acceso no autorizado' }
  end

  def create
    @series = Series.find(params[:series_id])
    temporada = params[:season_number].to_i
    id_temporada = agregar_season(@series, temporada)
    @chapter = Chapter.new(chapter_params.merge(season_id: id_temporada,
                                                rating: 1.0))
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
    if user.chapters_views.include?(@chapter)
      actual = @chapter.ratings.where(user_id: user.id).first
      if actual.nil?
        ChaptersRating.create(user_id: user.id,
                              chapter_id: @chapter.id,
                              rating: params[:rating].to_i)
      else
        actual.rating = params[:rating].to_i
        actual.save
      end
      recalcular_rating(@chapter)
    end
    redirect_to series_chapter_path(@series, @chapter)
  end

  def unview
    user = current_user
    if user.chapters_views.include?(@chapter)
      user.chapters_views.delete(@chapter)
      rating = @chapter.ratings.where(user_id: user.id).first
      if rating
        rating.destroy
        recalcular_rating @chapter
      end
    else
      user.chapters_views << @chapter
    end
    redirect_to series_chapter_path(@series, @chapter)
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
    temporada.destroy if temporada.chapters.empty?
  end

  def set_chapter
    @chapter = Chapter.find(params[:id])
    @series = Series.find(params[:series_id])
  end

  def chapter_params
    params.require(:chapter).permit(:name, :duration,
                                    :rating, :chapter_number)
  end
end
