require 'test_helper'

class ItemControllerTest < ActionController::TestCase
  test "should get browse" do
    get :browse
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

end
