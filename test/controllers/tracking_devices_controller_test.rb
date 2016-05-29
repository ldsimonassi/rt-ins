require 'test_helper'

class TrackingDevicesControllerTest < ActionController::TestCase
  setup do
    @tracking_device = tracking_devices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tracking_devices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tracking_device" do
    assert_difference('TrackingDevice.count') do
      post :create, tracking_device: { device_model_id: @tracking_device.device_model_id, serial_no: @tracking_device.serial_no }
    end

    assert_redirected_to tracking_device_path(assigns(:tracking_device))
  end

  test "should show tracking_device" do
    get :show, id: @tracking_device
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tracking_device
    assert_response :success
  end

  test "should update tracking_device" do
    patch :update, id: @tracking_device, tracking_device: { device_model_id: @tracking_device.device_model_id, serial_no: @tracking_device.serial_no }
    assert_redirected_to tracking_device_path(assigns(:tracking_device))
  end

  test "should destroy tracking_device" do
    assert_difference('TrackingDevice.count', -1) do
      delete :destroy, id: @tracking_device
    end

    assert_redirected_to tracking_devices_path
  end
end
