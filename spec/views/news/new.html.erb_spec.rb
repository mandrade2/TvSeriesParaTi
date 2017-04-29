require 'rails_helper'

RSpec.describe "news/new", type: :view do
  before(:each) do
    assign(:news, News.new(
      :title => "MyString",
      :content => "MyText",
      :user => nil
    ))
  end

  it "renders new news form" do
    render

    assert_select "form[action=?][method=?]", news_index_path, "post" do

      assert_select "input#news_title[name=?]", "news[title]"

      assert_select "textarea#news_content[name=?]", "news[content]"

      assert_select "input#news_user_id[name=?]", "news[user_id]"
    end
  end
end
