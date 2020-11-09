require "application_system_test_case"

class CabinetsTest < ApplicationSystemTestCase
  setup do
    @cabinet = cabinets(:one)
  end

  test "visiting the index" do
    visit cabinets_url
    assert_selector "h1", text: "Cabinets"
  end

  test "creating a Cabinet" do
    visit cabinets_url
    click_on "New Cabinet"

    click_on "Create Cabinet"

    assert_text "Cabinet was successfully created"
    click_on "Back"
  end

  test "updating a Cabinet" do
    visit cabinets_url
    click_on "Edit", match: :first

    click_on "Update Cabinet"

    assert_text "Cabinet was successfully updated"
    click_on "Back"
  end

  test "destroying a Cabinet" do
    visit cabinets_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Cabinet was successfully destroyed"
  end
end
