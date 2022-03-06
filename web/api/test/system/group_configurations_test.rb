require "application_system_test_case"

class GroupConfigurationsTest < ApplicationSystemTestCase
  setup do
    @group_configuration = group_configurations(:one)
  end

  test "visiting the index" do
    visit group_configurations_url
    assert_selector "h1", text: "Group Configurations"
  end

  test "creating a Group configuration" do
    visit group_configurations_url
    click_on "New Group Configuration"

    click_on "Create Group configuration"

    assert_text "Group configuration was successfully created"
    click_on "Back"
  end

  test "updating a Group configuration" do
    visit group_configurations_url
    click_on "Edit", match: :first

    click_on "Update Group configuration"

    assert_text "Group configuration was successfully updated"
    click_on "Back"
  end

  test "destroying a Group configuration" do
    visit group_configurations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Group configuration was successfully destroyed"
  end
end
