require 'test_helper'

class NoticiaTest < ActiveSupport::TestCase

  def setup
    @user = users(:one)
    @noticia = @user.noticiums.build(content: "Lorem ipsum", title: "Primera not")
  end

  test "should be valid" do
    assert @noticia.valid?
  end

  test "user id should be present" do
    @noticia.user_id = nil
    assert_not @noticia.valid?
  end
  test "content should be present" do
    @noticia.content = "   "
    assert_not @noticia.valid?
  end

  test "content should be at most 1000 characters" do
    @noticia.content = "a" * 1001
    assert_not @noticia.valid?
  end
  test "title should be present" do
    @noticia.title = "   "
    assert_not @noticia.valid?
  end

  test "title should be at most 140 characters" do
    @noticia.title= "a" * 141
    assert_not @noticia.valid?
  end
  test "order should be most recent first" do
    assert_equal noticium(:most_recent), Noticium.first
  end
end