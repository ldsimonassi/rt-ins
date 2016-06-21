require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  test "should get by_vehicle" do
    get :by_vehicle
    assert_response :success
  end

  test "should get by_user" do
    get :by_user
    assert_response :success
  end

end
