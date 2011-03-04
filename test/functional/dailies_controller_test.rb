require 'test_helper'

class DailiesControllerTest < ActionController::TestCase
  setup do
    @daily = dailies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dailies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create daily" do
    assert_difference('Daily.count') do
      post :create, :daily => @daily.attributes
    end

    assert_redirected_to daily_path(assigns(:daily))
  end

  test "should show daily" do
    get :show, :id => @daily.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @daily.to_param
    assert_response :success
  end

  test "should update daily" do
    put :update, :id => @daily.to_param, :daily => @daily.attributes
    assert_redirected_to daily_path(assigns(:daily))
  end

  test "should destroy daily" do
    assert_difference('Daily.count', -1) do
      delete :destroy, :id => @daily.to_param
    end

    assert_redirected_to dailies_path
  end
end
