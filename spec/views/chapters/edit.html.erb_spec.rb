require 'rails_helper'

RSpec.describe "chapters/edit", type: :view do
  before(:each) do
    @chapter = assign(:chapter, Chapter.create!(
      :name => "MyString",
      :duration => "MyString",
      :series => nil,
      :user => nil,
      :rating => 1
    ))
  end

  it "renders the edit chapter form" do
    render

    assert_select "form[action=?][method=?]", chapter_path(@chapter), "post" do

      assert_select "input#chapter_name[name=?]", "chapter[name]"

      assert_select "input#chapter_duration[name=?]", "chapter[duration]"

      assert_select "input#chapter_series_id[name=?]", "chapter[series_id]"

      assert_select "input#chapter_user_id[name=?]", "chapter[user_id]"

      assert_select "input#chapter_rating[name=?]", "chapter[rating]"
    end
  end
end
