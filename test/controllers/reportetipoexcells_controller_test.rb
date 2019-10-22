require 'test_helper'

class ReportetipoexcellsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reportetipoexcell = reportetipoexcells(:one)
  end

  test "should get index" do
    get reportetipoexcells_url
    assert_response :success
  end

  test "should get new" do
    get new_reportetipoexcell_url
    assert_response :success
  end

  test "should create reportetipoexcell" do
    assert_difference('Reportetipoexcell.count') do
      post reportetipoexcells_url, params: { reportetipoexcell: { fecha: @reportetipoexcell.fecha, in: @reportetipoexcell.in, net: @reportetipoexcell.net, out: @reportetipoexcell.out } }
    end

    assert_redirected_to reportetipoexcell_url(Reportetipoexcell.last)
  end

  test "should show reportetipoexcell" do
    get reportetipoexcell_url(@reportetipoexcell)
    assert_response :success
  end

  test "should get edit" do
    get edit_reportetipoexcell_url(@reportetipoexcell)
    assert_response :success
  end

  test "should update reportetipoexcell" do
    patch reportetipoexcell_url(@reportetipoexcell), params: { reportetipoexcell: { fecha: @reportetipoexcell.fecha, in: @reportetipoexcell.in, net: @reportetipoexcell.net, out: @reportetipoexcell.out } }
    assert_redirected_to reportetipoexcell_url(@reportetipoexcell)
  end

  test "should destroy reportetipoexcell" do
    assert_difference('Reportetipoexcell.count', -1) do
      delete reportetipoexcell_url(@reportetipoexcell)
    end

    assert_redirected_to reportetipoexcells_url
  end
end
