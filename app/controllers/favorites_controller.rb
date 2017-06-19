class FavoritesController < ApplicationController
  before_action :set_favorites, only: %i[create destroy]

  def index
    @user = current_user
    @series = current_user.favorite_series
    @chapters = current_user.favorite_chapters
  end

  def create
    current_user.favorite_series << @series unless @series.nil?
    current_user.favorite_chapters << @chapter unless @chapter.nil?
    redirect_to @series unless @series.nil?
    unless @chapter.nil?
      redirect_to series_chapter_path(@chapter.season.series, @chapter)
    end
  end

  def destroy
    current_user.favorite_series.delete(@series) unless @series.nil?
    current_user.favorite_chapters.delete(@chapter) unless @chapter.nil?
    redirect_to @series unless @series.nil?
    unless @chapter.nil?
      redirect_to series_chapter_path(@chapter.season.series, @chapter)
    end
  end

  def set_favorites
    @series = Series.find(params[:series_id]) if params[:series_id]
    @chapter = Chapter.find(params[:chapter_id]) if params[:chapter_id]
  end
end
