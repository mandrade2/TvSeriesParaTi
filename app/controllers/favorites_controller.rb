class FavoritesController < ApplicationController
  before_action :set_favorites, only: %i[create destroy]

  def index
    @user = current_user
    @series = current_user.favorite_series
    @chapters = current_user.favorite_chapters
  end

  def create
    if @topic == :series
      current_user.favorite_series << @series
      redirect_to @series
    elsif @topic == :chapter
      current_user.favorite_chapters << @chapter
      redirect_to series_chapter_path(@chapter.season.series, @chapter)
    else
      redirect_to root_path, flash: {alert: 'Ocurrio un error inesperado'}
    end
  end

  def destroy
    if @topic == :series
      current_user.favorite_series.delete(@series)
      redirect_to @series
    elsif @topic == :chapter
      current_user.favorite_chapters.delete(@chapter)
      redirect_to series_chapter_path(@chapter.season.series, @chapter)
    else
      redirect_to root_path, flash: {alert: 'Ocurrio un error inesperado'}
    end
  end

  def set_favorites
    @topic = nil
    if params[:series_id]
      @series = Series.find(params[:series_id])
      @topic = :series
    end
    return unless params[:chapter_id]
    @chapter = Chapter.find(params[:chapter_id])
    @topic = :chapter
  end
end
