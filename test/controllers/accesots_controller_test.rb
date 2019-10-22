require 'test_helper'

class AccesotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @accesot = accesots(:one)
  end

  test "should get index" do
    get accesots_url
    assert_response :success
  end

  test "should get new" do
    get new_accesot_url
    assert_response :success
  end

  test "should create accesot" do
    assert_difference('Accesot.count') do
      post accesots_url, params: { accesot: { fechayhora: @accesot.fechayhora, ip: @accesot.ip, tipoacceso: @accesot.tipoacceso, usuario: @accesot.usuario } }
    end

    assert_redirected_to accesot_url(Accesot.last)
  end

  test "should show accesot" do
    get accesot_url(@accesot)
    assert_response :success
  end

  test "should get edit" do
    get edit_accesot_url(@accesot)
    assert_response :success
  end

  test "should update accesot" do
    patch accesot_url(@accesot), params: { accesot: { fechayhora: @accesot.fechayhora, ip: @accesot.ip, tipoacceso: @accesot.tipoacceso, usuario: @accesot.usuario } }
    assert_redirected_to accesot_url(@accesot)
  end

  test "should destroy accesot" do
    assert_difference('Accesot.count', -1) do
      delete accesot_url(@accesot)
    end

    assert_redirected_to accesots_url
  end
end
