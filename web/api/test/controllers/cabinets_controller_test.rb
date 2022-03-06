require 'test_helper'

class CabinetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cabinet = cabinets(:one)
  end

  test "should get index" do
    get cabinets_url
    assert_response :success
  end

  test "should get new" do
    get new_cabinet_url
    assert_response :success
  end

  test "should create cabinet" do
    assert_difference('Cabinet.count') do
      post cabinets_url, params: { cabinet: {  } }
    end

    assert_redirected_to cabinet_url(Cabinet.last)
  end

  test "should show cabinet" do
    get cabinet_url(@cabinet)
    assert_response :success
  end

  test "should get edit" do
    get edit_cabinet_url(@cabinet)
    assert_response :success
  end

  test "should update cabinet" do
    patch cabinet_url(@cabinet), params: { cabinet: {  } }
    assert_redirected_to cabinet_url(@cabinet)
  end

  test "should destroy cabinet" do
    assert_difference('Cabinet.count', -1) do
      delete cabinet_url(@cabinet)
    end

    assert_redirected_to cabinets_url
  end
end
