require "application_system_test_case"

class SiteUrlsTest < ApplicationSystemTestCase
  setup do
    @site_url = site_urls(:one)
  end

  test "visiting the index" do
    visit site_urls_url
    assert_selector "h1", text: "Site Urls"
  end

  test "creating a Site url" do
    visit site_urls_url
    click_on "New Site Url"

    fill_in "Code", with: @site_url.code
    fill_in "Req method", with: @site_url.req_method
    fill_in "Site", with: @site_url.site
    fill_in "Url", with: @site_url.url
    click_on "Create Site url"

    assert_text "Site url was successfully created"
    click_on "Back"
  end

  test "updating a Site url" do
    visit site_urls_url
    click_on "Edit", match: :first

    fill_in "Code", with: @site_url.code
    fill_in "Req method", with: @site_url.req_method
    fill_in "Site", with: @site_url.site
    fill_in "Url", with: @site_url.url
    click_on "Update Site url"

    assert_text "Site url was successfully updated"
    click_on "Back"
  end

  test "destroying a Site url" do
    visit site_urls_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Site url was successfully destroyed"
  end
end
