require 'test_helper'

class TwilioControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
