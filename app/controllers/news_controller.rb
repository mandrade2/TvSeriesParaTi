class NewsController < ApplicationController
  before_action :set_news, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]
  before_action :authenticate_not_child, except: %i[index show]

  def index
    @news = News.all.order(:created_at).includes(:user)
  end

  def show; end

  def new
    @news = News.new
  end

  def edit
    return if @news.user == current_user
    redirect_to root_path, flash: { danger: 'Acceso no autorizado' }
  end

  def create
    @news = News.new(news_params.merge(user_id: current_user.id))
    respond_to do |format|
      if @news.save
        format.html do
          redirect_to @news,
                      flash: { success: 'Noticia fue creada correctamente' }
        end
        format.json { render :show, status: :created, location: @news }
      else
        format.html { render :new }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @news.update(news_params)
        format.html do
          redirect_to @news,
                      flash: {
                        success: 'Noticia fue actualizada correctamente'
                      }
        end
        format.json { render :show, status: :ok, location: @news }
      else
        format.html { render :edit }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @news.destroy
    respond_to do |format|
      format.html do
        redirect_to news_index_url,
                    flash: { success: 'News was successfully destroyed.' }
      end
      format.json { head :no_content }
    end
  end

  private

  def set_news
    @news = News.find(params[:id])
  end

  def news_params
    params.require(:news).permit(:title, :content, :user_id)
  end
end
