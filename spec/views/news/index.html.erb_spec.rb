require 'rails_helper'

RSpec.describe "news/index", type: :view do
  before(:each) do
    assign(:news, [
      News.create!(
        :title => "Title",
        :content => "MyText",
        :user => nil
      ),
      News.create!(
        :title => "Title",
        :content => "MyText",
        :user => nil
      )
    ])
  end

  it "renders a list of news" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
