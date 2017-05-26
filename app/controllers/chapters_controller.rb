class ChaptersController < ApplicationController
  before_action :set_chapter, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]

  def index
    @series = Series.find(params[:series_id])
    @chapters = @series.chapters
  end

  def show; end

  def new
    @chapter = Chapter.new
    @series = Series.find(params[:series_id])
  end

  def edit; end

  def create
    @chapter = Chapter.new(chapter_params.merge(series_id: params[:series_id],
                                                user_id: current_user.id))
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
    params.require(:chapter).permit(:name, :duration,
                                    :rating, :chapter_number)
  end
end
