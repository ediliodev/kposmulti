require 'test_helper'

class ReportetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reportet = reportets(:one)
  end

  test "should get index" do
    get reportets_url
    assert_response :success
  end

  test "should get new" do
    get new_reportet_url
    assert_response :success
  end

  test "should create reportet" do
    assert_difference('Reportet.count') do
      post reportets_url, params: { reportet: { desde: @reportet.desde, hasta: @reportet.hasta } }
    end

    assert_redirected_to reportet_url(Reportet.last)
  end

  test "should show reportet" do
    get reportet_url(@reportet)
    assert_response :success
  end

  test "should get edit" do
    get edit_reportet_url(@reportet)
    assert_response :success
  end

  test "should update reportet" do
    patch reportet_url(@reportet), params: { reportet: { desde: @reportet.desde, hasta: @reportet.hasta } }
    assert_redirected_to reportet_url(@reportet)
  end

  test "should destroy reportet" do
    assert_difference('Reportet.count', -1) do
      delete reportet_url(@reportet)
    end

    assert_redirected_to reportets_url
  end
end
