class ChaptersController < ApplicationController
  before_action :set_chapter, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]

  # GET /chapters
  # GET /chapters.json
  def index
    @series = Series.find(params[:series_id])
    @chapters = @series.chapters
  end

  # GET /chapters/1
  # GET /chapters/1.json
  def show; end

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
    @chapter = Chapter.new(chapter_params.merge(series_id: params[:series_id]))
    respond_to do |format|
      if @chapter.save
        format.html do
          redirect_to series_chapter_path(@chapter.series, @chapter),
                      flash: { success: 'Capitulo fue creado correctamente' }
        end
        format.json { render :show, status: :created, location: @chapter }
      else
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
    @series = @chapter.series
    @chapter.destroy
    respond_to do |format|
      format.html do
        redirect_to series_chapters_path(@series),
                    flash: { success: 'Capitulo fue destruido correctamente' }
      end
      format.json { head :no_content }
    end
  end

  private

  def set_chapter
    @chapter = Chapter.find(params[:id])
    @series = @chapter.series
  end

  def chapter_params
    params.require(:chapter).permit(:name, :duration, :user_id, :rating)
  end
end
