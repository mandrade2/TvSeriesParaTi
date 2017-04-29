require 'rails_helper'

RSpec.describe "news/edit", type: :view do
  before(:each) do
    @news = assign(:news, create(:news))
  end

  it "renders the edit news form" do
    render

    assert_select "form[action=?][method=?]", news_path(@news), "post" do

      assert_select "input#news_title[name=?]", "news[title]"

      assert_select "textarea#news_content[name=?]", "news[content]"

      assert_select "input#news_user_id[name=?]", "news[user_id]"
    end
  end
end
