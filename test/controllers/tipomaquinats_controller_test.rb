require 'test_helper'

class TipomaquinatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tipomaquinat = tipomaquinats(:one)
  end

  test "should get index" do
    get tipomaquinats_url
    assert_response :success
  end

  test "should get new" do
    get new_tipomaquinat_url
    assert_response :success
  end

  test "should create tipomaquinat" do
    assert_difference('Tipomaquinat.count') do
      post tipomaquinats_url, params: { tipomaquinat: { descripcion: @tipomaquinat.descripcion, tipomaquina: @tipomaquinat.tipomaquina } }
    end

    assert_redirected_to tipomaquinat_url(Tipomaquinat.last)
  end

  test "should show tipomaquinat" do
    get tipomaquinat_url(@tipomaquinat)
    assert_response :success
  end

  test "should get edit" do
    get edit_tipomaquinat_url(@tipomaquinat)
    assert_response :success
  end

  test "should update tipomaquinat" do
    patch tipomaquinat_url(@tipomaquinat), params: { tipomaquinat: { descripcion: @tipomaquinat.descripcion, tipomaquina: @tipomaquinat.tipomaquina } }
    assert_redirected_to tipomaquinat_url(@tipomaquinat)
  end

  test "should destroy tipomaquinat" do
    assert_difference('Tipomaquinat.count', -1) do
      delete tipomaquinat_url(@tipomaquinat)
    end

    assert_redirected_to tipomaquinats_url
  end
end
