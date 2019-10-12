require 'test_helper'

class LocalidadtsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @localidadt = localidadts(:one)
  end

  test "should get index" do
    get localidadts_url
    assert_response :success
  end

  test "should get new" do
    get new_localidadt_url
    assert_response :success
  end

  test "should create localidadt" do
    assert_difference('Localidadt.count') do
      post localidadts_url, params: { localidadt: { consorcio: @localidadt.consorcio, direccion: @localidadt.direccion, sucursal: @localidadt.sucursal } }
    end

    assert_redirected_to localidadt_url(Localidadt.last)
  end

  test "should show localidadt" do
    get localidadt_url(@localidadt)
    assert_response :success
  end

  test "should get edit" do
    get edit_localidadt_url(@localidadt)
    assert_response :success
  end

  test "should update localidadt" do
    patch localidadt_url(@localidadt), params: { localidadt: { consorcio: @localidadt.consorcio, direccion: @localidadt.direccion, sucursal: @localidadt.sucursal } }
    assert_redirected_to localidadt_url(@localidadt)
  end

  test "should destroy localidadt" do
    assert_difference('Localidadt.count', -1) do
      delete localidadt_url(@localidadt)
    end

    assert_redirected_to localidadts_url
  end
end
