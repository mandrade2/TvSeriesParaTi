class FavoritesController < ApplicationController
  def index
    @user = current_user
    @series = current_user.favorite_series
    @chapters = current_user.favorite_chapters
  end

  def create
  end

  def destroy
  end
end
