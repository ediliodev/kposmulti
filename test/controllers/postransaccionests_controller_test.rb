require 'test_helper'

class PostransaccionestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @postransaccionest = postransaccionests(:one)
  end

  test "should get index" do
    get postransaccionests_url
    assert_response :success
  end

  test "should get new" do
    get new_postransaccionest_url
    assert_response :success
  end

  test "should create postransaccionest" do
    assert_difference('Postransaccionest.count') do
      post postransaccionests_url, params: { postransaccionest: { cantidad: @postransaccionest.cantidad, serial: @postransaccionest.serial } }
    end

    assert_redirected_to postransaccionest_url(Postransaccionest.last)
  end

  test "should show postransaccionest" do
    get postransaccionest_url(@postransaccionest)
    assert_response :success
  end

  test "should get edit" do
    get edit_postransaccionest_url(@postransaccionest)
    assert_response :success
  end

  test "should update postransaccionest" do
    patch postransaccionest_url(@postransaccionest), params: { postransaccionest: { cantidad: @postransaccionest.cantidad, serial: @postransaccionest.serial } }
    assert_redirected_to postransaccionest_url(@postransaccionest)
  end

  test "should destroy postransaccionest" do
    assert_difference('Postransaccionest.count', -1) do
      delete postransaccionest_url(@postransaccionest)
    end

    assert_redirected_to postransaccionests_url
  end
end
