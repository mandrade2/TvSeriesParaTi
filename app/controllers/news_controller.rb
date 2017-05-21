class NewsController < ApplicationController
  before_action :set_news, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: %i[index show]


  # GET /news
  # GET /news.json
  def index
    if params[:q]
      query=params[:q]
      @search = News.search do
        keywords query
      end
      @news=@search.results
    else
      @news=News.all
    end
  end

  # GET /news/1
  # GET /news/1.json
  def show; end

  # GET /news/new
  def new
    @news = News.new
  end

  # GET /news/1/edit
  def edit; end

  # POST /news
  # POST /news.json
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

  # PATCH/PUT /news/1
  # PATCH/PUT /news/1.json
  def update
    respond_to do |format|
      if @news.update(news_params)
        format.html do
          redirect_to @news,
                      flash: { success: 'Noticia fue actualizada correctamente' }
        end
        format.json { render :show, status: :ok, location: @news }
      else
        format.html { render :edit }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /news/1
  # DELETE /news/1.json
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
    params.require(:news).permit(:title, :content, :user_id,:q)
  end
end
