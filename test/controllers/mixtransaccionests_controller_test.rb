require 'test_helper'

class MixtransaccionestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mixtransaccionest = mixtransaccionests(:one)
  end

  test "should get index" do
    get mixtransaccionests_url
    assert_response :success
  end

  test "should get new" do
    get new_mixtransaccionest_url
    assert_response :success
  end

  test "should create mixtransaccionest" do
    assert_difference('Mixtransaccionest.count') do
      post mixtransaccionests_url, params: { mixtransaccionest: { cantidad: @mixtransaccionest.cantidad, comando: @mixtransaccionest.comando, descripcion: @mixtransaccionest.descripcion, maquinat_id: @mixtransaccionest.maquinat_id, status: @mixtransaccionest.status, tipotransaccion: @mixtransaccionest.tipotransaccion } }
    end

    assert_redirected_to mixtransaccionest_url(Mixtransaccionest.last)
  end

  test "should show mixtransaccionest" do
    get mixtransaccionest_url(@mixtransaccionest)
    assert_response :success
  end

  test "should get edit" do
    get edit_mixtransaccionest_url(@mixtransaccionest)
    assert_response :success
  end

  test "should update mixtransaccionest" do
    patch mixtransaccionest_url(@mixtransaccionest), params: { mixtransaccionest: { cantidad: @mixtransaccionest.cantidad, comando: @mixtransaccionest.comando, descripcion: @mixtransaccionest.descripcion, maquinat_id: @mixtransaccionest.maquinat_id, status: @mixtransaccionest.status, tipotransaccion: @mixtransaccionest.tipotransaccion } }
    assert_redirected_to mixtransaccionest_url(@mixtransaccionest)
  end

  test "should destroy mixtransaccionest" do
    assert_difference('Mixtransaccionest.count', -1) do
      delete mixtransaccionest_url(@mixtransaccionest)
    end

    assert_redirected_to mixtransaccionests_url
  end
end
