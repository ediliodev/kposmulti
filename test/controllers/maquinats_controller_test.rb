require 'test_helper'

class MaquinatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @maquinat = maquinats(:one)
  end

  test "should get index" do
    get maquinats_url
    assert_response :success
  end

  test "should get new" do
    get new_maquinat_url
    assert_response :success
  end

  test "should create maquinat" do
    assert_difference('Maquinat.count') do
      post maquinats_url, params: { maquinat: { descripcion: @maquinat.descripcion, tipomaquinat_id: @maquinat.tipomaquinat_id } }
    end

    assert_redirected_to maquinat_url(Maquinat.last)
  end

  test "should show maquinat" do
    get maquinat_url(@maquinat)
    assert_response :success
  end

  test "should get edit" do
    get edit_maquinat_url(@maquinat)
    assert_response :success
  end

  test "should update maquinat" do
    patch maquinat_url(@maquinat), params: { maquinat: { descripcion: @maquinat.descripcion, tipomaquinat_id: @maquinat.tipomaquinat_id } }
    assert_redirected_to maquinat_url(@maquinat)
  end

  test "should destroy maquinat" do
    assert_difference('Maquinat.count', -1) do
      delete maquinat_url(@maquinat)
    end

    assert_redirected_to maquinats_url
  end
end
