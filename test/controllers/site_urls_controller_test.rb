require 'test_helper'

class SiteUrlsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @site_url = site_urls(:one)
  end

  test "should get index" do
    get site_urls_url
    assert_response :success
  end

  test "should get new" do
    get new_site_url_url
    assert_response :success
  end

  test "should create site_url" do
    assert_difference('SiteUrl.count') do
      post site_urls_url, params: { site_url: { code: @site_url.code, req_method: @site_url.req_method, site: @site_url.site, url: @site_url.url } }
    end

    assert_redirected_to site_url_url(SiteUrl.last)
  end

  test "should show site_url" do
    get site_url_url(@site_url)
    assert_response :success
  end

  test "should get edit" do
    get edit_site_url_url(@site_url)
    assert_response :success
  end

  test "should update site_url" do
    patch site_url_url(@site_url), params: { site_url: { code: @site_url.code, req_method: @site_url.req_method, site: @site_url.site, url: @site_url.url } }
    assert_redirected_to site_url_url(@site_url)
  end

  test "should destroy site_url" do
    assert_difference('SiteUrl.count', -1) do
      delete site_url_url(@site_url)
    end

    assert_redirected_to site_urls_url
  end
end
