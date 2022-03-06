require 'test_helper'

class GroupConfigurationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group_configuration = group_configurations(:one)
  end

  test "should get index" do
    get group_configurations_url
    assert_response :success
  end

  test "should get new" do
    get new_group_configuration_url
    assert_response :success
  end

  test "should create group_configuration" do
    assert_difference('GroupConfiguration.count') do
      post group_configurations_url, params: { group_configuration: {  } }
    end

    assert_redirected_to group_configuration_url(GroupConfiguration.last)
  end

  test "should show group_configuration" do
    get group_configuration_url(@group_configuration)
    assert_response :success
  end

  test "should get edit" do
    get edit_group_configuration_url(@group_configuration)
    assert_response :success
  end

  test "should update group_configuration" do
    patch group_configuration_url(@group_configuration), params: { group_configuration: {  } }
    assert_redirected_to group_configuration_url(@group_configuration)
  end

  test "should destroy group_configuration" do
    assert_difference('GroupConfiguration.count', -1) do
      delete group_configuration_url(@group_configuration)
    end

    assert_redirected_to group_configurations_url
  end
end
