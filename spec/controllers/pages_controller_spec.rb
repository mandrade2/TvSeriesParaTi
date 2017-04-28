require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET pages' do
    it 'renders home page' do
      get :home
      expect(response).to render_template('pages/home')
    end

    it 'renders contact page' do
      get :contact
      expect(response).to render_template('pages/contact')
    end

    it 'renders about page' do
      get :about
      expect(response).to render_template('pages/about')
    end

    it 'renders news page' do
      get :news
      expect(response).to render_template('pages/news')
    end

    it 'renders help page' do
      get :help
      expect(response).to render_template('pages/help')
    end
  end
end
