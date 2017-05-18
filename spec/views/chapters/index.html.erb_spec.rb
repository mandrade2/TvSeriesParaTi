require 'rails_helper'

RSpec.describe "chapters/index", type: :view do
  before(:each) do
    assign(:chapters, [
      Chapter.create!(
        :name => "Name",
        :duration => "Duration",
        :series => nil,
        :user => nil,
        :rating => 2
      ),
      Chapter.create!(
        :name => "Name",
        :duration => "Duration",
        :series => nil,
        :user => nil,
        :rating => 2
      )
    ])
  end

  it "renders a list of chapters" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Duration".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
