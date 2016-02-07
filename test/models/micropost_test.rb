require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:clair)
    @micropost = @user.microposts.new(content: "Lorem Ipsum", user_id: @user.id)
  end
  
  test "should be valid" do
    assert @micropost.valid?
  end
  
  test "id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  
  test "content should be present" do
    @micropost.content = ""
    assert_not @micropost.valid?
  end
  
  test "content should be no longer than 140 characters" do
    @micropost.content = "a"*141
    assert_not @micropost.valid?
  end
  
  test "content should be most recent first" do
    # Friday was set up as the fixture with the most recent datetime
    assert_equal microposts(:friday), Micropost.first
  end
end
