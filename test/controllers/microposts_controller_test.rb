require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase
  def setup
    @micropost = microposts(:tuesday)
  end
  
  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post :create, micropost: { content: "Lorem Ipsum"}
    end
    # Redirect is a result of running the logged_in_user action located in the application_controller
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      post :destroy, id: @micropost
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:clair))
    micropost = microposts(:wednesday)
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: micropost
    end
    assert_redirected_to root_url
  end
  
end
