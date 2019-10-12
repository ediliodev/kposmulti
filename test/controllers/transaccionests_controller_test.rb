require 'test_helper'

class TransaccionestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @transaccionest = transaccionests(:one)
  end

  test "should get index" do
    get transaccionests_url
    assert_response :success
  end

  test "should get new" do
    get new_transaccionest_url
    assert_response :success
  end

  test "should create transaccionest" do
    assert_difference('Transaccionest.count') do
      post transaccionests_url, params: { transaccionest: { cantidad: @transaccionest.cantidad, maquinat_id: @transaccionest.maquinat_id, status: @transaccionest.status, tipotransaccion: @transaccionest.tipotransaccion } }
    end

    assert_redirected_to transaccionest_url(Transaccionest.last)
  end

  test "should show transaccionest" do
    get transaccionest_url(@transaccionest)
    assert_response :success
  end

  test "should get edit" do
    get edit_transaccionest_url(@transaccionest)
    assert_response :success
  end

  test "should update transaccionest" do
    patch transaccionest_url(@transaccionest), params: { transaccionest: { cantidad: @transaccionest.cantidad, maquinat_id: @transaccionest.maquinat_id, status: @transaccionest.status, tipotransaccion: @transaccionest.tipotransaccion } }
    assert_redirected_to transaccionest_url(@transaccionest)
  end

  test "should destroy transaccionest" do
    assert_difference('Transaccionest.count', -1) do
      delete transaccionest_url(@transaccionest)
    end

    assert_redirected_to transaccionests_url
  end
end
