require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  
  def setup
    @user = users(:clair)
  end
  
  test "Check profile page for user" do
    get user_path(@user)
    assert_template 'users/show'
    # Full title was a method we wrote in the application_helper.rb file
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    # response.body give you the HTML for the entire page
    # Below is just looking for the number of microposts to be displayed SOMEWHERE on the page
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
  
end
