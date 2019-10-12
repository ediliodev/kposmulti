class ReportetsController < ApplicationController
  before_action :set_reportet, only: [:show, :edit, :update, :destroy]

  # GET /reportets
  # GET /reportets.json
  def index
    #@reportets = Reportet.all

 # @primero = ganadores.primero < 10 ? ("0" + ganadores.primero.to_s) : ganadores.primero.to_s
    session[:fecha_venta_dia_1].values[2] = session[:fecha_venta_dia_1].values[2].to_i < 10 ? (session[:fecha_venta_dia_1].values[2] = "0" + session[:fecha_venta_dia_1].values[2] ) : (session[:fecha_venta_dia_1].values[2])
    session[:fecha_venta_dia_2].values[2] = session[:fecha_venta_dia_2].values[2].to_i < 10 ? (session[:fecha_venta_dia_2].values[2] = "0" + session[:fecha_venta_dia_2].values[2] ) : (session[:fecha_venta_dia_2].values[2])

    @dia1 = session[:fecha_venta_dia_1].values.reverse.join("-") # hash.values retorna array. para la consulta de by_day(fehca en ingles yyyy-mm-dd)    
    @dia2 = session[:fecha_venta_dia_2].values.reverse.join("-")

    # lo sigeuinte es para evitar que el 31-10-2018 sea mayor que el 01-11-2018 en la comparacion de fecha.to_i (agregar 0 deciumal que falta en noviembre)
    #@dia1 => "2018-10-31" 
    @day = @dia2.split("-")[2].to_i < 10 ? "0"+@dia2.split("-")[2] : @dia2.split("-")[2]
    ymd = @dia2.split("-")
    ymd[2] = @day
    @dia2 = ymd.join("-")

    # Lo mismo pada dia1 porque tambien tiene el mismo error. 5 => 05 ok.
    @day = @dia1.split("-")[2].to_i < 10 ? "0"+@dia1.split("-")[2] : @dia1.split("-")[2]
    ymd = @dia1.split("-")
    ymd[2] = @day
    @dia1 = ymd.join("-")


    if @dia1.split("-").join("").to_i > @dia2.split("-").join("").to_i
       redirect_to "/reportets/new", notice: "Fecha final debe se mayor a la fecha de inicio." and return
    end

    y, m, d = @dia2.to_s.split("-")

    if not (Date.valid_date? y.to_i, m.to_i, d.to_i) # sacado de link: https://stackoverflow.com/questions/2955830/how-to-check-if-a-string-is-a-valid-date
      redirect_to "/reportets/new", notice: "Debe elegir una fecha final valida. Ej. favor verifiicar si el mes es de 30 o 31 dias." and return
    end

    y, m, d = @dia1.to_s.split("-")
    
    if not (Date.valid_date? y.to_i, m.to_i, d.to_i) # sacado de link: https://stackoverflow.com/questions/2955830/how-to-check-if-a-string-is-a-valid-date
      redirect_to "/reportets/new", notice: "Debe elegir una fecha de inicio valida. Ej. favor verifiicar si el mes es de 30 o 31 dias." and return
    end

    @dia2 = @dia2.to_date.tomorrow # + 1.day    #como en between simepre empieza al inicio del dia, o sea a la media noche, La fecha final le sumaremos un dia para que seal igual al final del dia elegido, que es igual al inicio del dia posterior al final deseado. O sea, desde inicio de A hasta inicio de C es igual a: Desde inicio de a hasta final de B. (Donde termina B empieza C) ok. Ted. Rails concole. ok.


    #@valor es ventas
    #Defino @objeto_array_ventas para no hacer dos consultas al ActiveRecord de @valor (sum) y de @cantidad_de_tickets_vendidos (count) ok ted.
  #  @objeto_array_ventas = Jugadalot.between_times(@dia1.to_date , @dia2 ).where(:ticket_id => Ticket.between_times(@dia1.to_date , @dia2 ).where(:user_id => current_user.id , :activo => "si").ids )
   
   # @valor = @objeto_array_ventas.sum(:monto) 
   # @cantidad_de_tickets_vendidos = @objeto_array_ventas.count



  
  #  @ganadores_cuadre = Ticketsganadorest.between_times(@dia1.to_date , @dia2).where(:sucursal => current_user.email.split('@')[0]).sum(:montoacobrar)

    #Tickets pendientes de pago son Todos los tickets ganadores de ese rango de fecha no pagados.sumatoria
  #  @cantidad_de_tickets_pendiente_de_pago = Ticketsganadorest.between_times(@dia1.to_date , @dia2 ).where(:ticket_id => Ticket.between_times(@dia1.to_date , @dia2 ).where(:user_id => current_user.id , :activo => "si", :ganador => "si", :pago => nil).ids).count

@total_in =  Transaccionest.between_times(@dia1.to_date, @dia2).where(:tipotransaccion => "credito", :status => "ok").sum(:cantidad)
@total_out =  Postransaccionest.between_times(@dia1.to_date, @dia2).sum(:cantidad)

@total_net = @total_in.to_i - @total_out.to_i

# Transaccionest id: 44, 
# maquinat_id: 1, 
# tipotransaccion: "credito",
#  cantidad: "100", 
#  status: "ok", 
#  created_at: "2019-07-26 06:06:11", 
#  updated_at: "2019-07-26 06:06:17", 
#  comando: "@cash100^">

# arreglos de objetos para mostrar la tabal de transacciones en ese rango de fechas:

# @consultas_transacciones =  Transaccionest.between_times(@dia1.to_date, @dia2).where(:tipotransaccion => in ["credito", "debito"], :status => "ok").sum(:cantidad)

#modificaciones provisionales para juntar el reporte detallado de ambas tablas Creditos/Debitos Modelos Transaccionest y Postransaccionest ted ok provisional work production ok v1.
@array_consultas_transacciones =  Transaccionest.between_times(@dia1.to_date, @dia2).where("tipotransaccion = ? or tipotransaccion = ?", "credito", "debito" )

@array_consultas_postransacciones = Postransaccionest.between_times(@dia1.to_date, @dia2)


@ids_maquinas_activas = Maquinat.where(:activa => "si").ids
session[:fecha_venta_detalladaxmaquina_dia_1] = @dia1.to_date # Esto para llevarme las fechas a imprimir con el loop de detallado x maquina en el index reporte de la vista (view index.html de la pagina) ok
session[:fecha_venta_detalladaxmaquina_dia_2] =  @dia2        # Esto para llevarme las fechas a imprimir con el loop de detallado x maquina en el index reporte de la vista (view index.html de la pagina) ok
#@detallada_in = Transaccionest.between_times(@dia1.to_date, @dia2).where(:maquinat_id => 77 ,  :tipotransaccion => "credito", :status => "ok").sum(:cantidad)
#@venta_detallada_por_maquina = Maquinat.where(:activa => "si").ids
#etc..


    #IMPORTANTE ESTA PARTE DE ABAJO EN LA VISTA TED OK KOLLECTOR FUSION PROJECT OK.

    @dia1 = session[:fecha_venta_dia_1].values.join("-") # para el show dd-mm-aaaa
    @dia2 = session[:fecha_venta_dia_2].values.join("-") # para el show dd-mm-aaaa

  
    session[:fecha_venta_dia_1] = nil # Limpio la variable para evitar cookie oversize en el cliente.
    session[:fecha_venta_dia_2] = nil # Limpio la variable para evitar cookie oversize en el cliente.
  
    
    # Gererar cadena de impresion de este cuadre para version impresion movil:

  end

  # GET /reportets/1
  # GET /reportets/1.json
  def show
  end

  # GET /reportets/new
  def new
    @reportet = Reportet.new
  end

  # GET /reportets/1/edit
  def edit
  end

  # POST /reportets
  # POST /reportets.json
  def create
    @fecha1 = params.require(:reportet).permit(:desde) 
    @fecha2 = params.require(:reportet).permit(:hasta) 
    session[:fecha_venta_dia_1] = @fecha1
    session[:fecha_venta_dia_2] = @fecha2
    redirect_to reportets_path and return  # el create lo manda al index con las variables de dias1 y dia2 para mostrar el reporte en el index view luego de ser procesado por el controller. ok ted.
  end

  # PATCH/PUT /reportets/1
  # PATCH/PUT /reportets/1.json
  def update
    respond_to do |format|
      if @reportet.update(reportet_params)
        format.html { redirect_to @reportet, notice: 'Reportet was successfully updated.' }
        format.json { render :show, status: :ok, location: @reportet }
      else
        format.html { render :edit }
        format.json { render json: @reportet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reportets/1
  # DELETE /reportets/1.json
  def destroy
    @reportet.destroy
    respond_to do |format|
      format.html { redirect_to reportets_url, notice: 'Reportet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reportet
      @reportet = Reportet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reportet_params
      params.require(:reportet).permit(:desde, :hasta)
    end
end



#*********************************##

class MenuposrventaxfechatsController < ApplicationController


  def index
    # @primero = ganadores.primero < 10 ? ("0" + ganadores.primero.to_s) : ganadores.primero.to_s
    session[:fecha_venta_dia_1].values[2] = session[:fecha_venta_dia_1].values[2].to_i < 10 ? (session[:fecha_venta_dia_1].values[2] = "0" + session[:fecha_venta_dia_1].values[2] ) : (session[:fecha_venta_dia_1].values[2])
    session[:fecha_venta_dia_2].values[2] = session[:fecha_venta_dia_2].values[2].to_i < 10 ? (session[:fecha_venta_dia_2].values[2] = "0" + session[:fecha_venta_dia_2].values[2] ) : (session[:fecha_venta_dia_2].values[2])

    @dia1 = session[:fecha_venta_dia_1].values.reverse.join("-") # hash.values retorna array. para la consulta de by_day(fehca en ingles yyyy-mm-dd)    
    @dia2 = session[:fecha_venta_dia_2].values.reverse.join("-")

    # lo sigeuinte es para evitar que el 31-10-2018 sea mayor que el 01-11-2018 en la comparacion de fecha.to_i (agregar 0 deciumal que falta en noviembre)
    #@dia1 => "2018-10-31" 
    @day = @dia2.split("-")[2].to_i < 10 ? "0"+@dia2.split("-")[2] : @dia2.split("-")[2]
    ymd = @dia2.split("-")
    ymd[2] = @day
    @dia2 = ymd.join("-")

    # Lo mismo pada dia1 porque tambien tiene el mismo error. 5 => 05 ok.
    @day = @dia1.split("-")[2].to_i < 10 ? "0"+@dia1.split("-")[2] : @dia1.split("-")[2]
    ymd = @dia1.split("-")
    ymd[2] = @day
    @dia1 = ymd.join("-")


    if @dia1.split("-").join("").to_i > @dia2.split("-").join("").to_i
       redirect_to "/menuposrventaxfechats/new", notice: "Fecha final debe se mayor a la fecha de inicio." and return
    end

    y, m, d = @dia2.to_s.split("-")

    if not (Date.valid_date? y.to_i, m.to_i, d.to_i) # sacado de link: https://stackoverflow.com/questions/2955830/how-to-check-if-a-string-is-a-valid-date
      redirect_to "/menuposrventaxfechats/new", notice: "Debe elegir una fecha final valida. Ej. favor verifiicar si el mes es de 30 o 31 dias." and return
    end

    y, m, d = @dia1.to_s.split("-")
    
    if not (Date.valid_date? y.to_i, m.to_i, d.to_i) # sacado de link: https://stackoverflow.com/questions/2955830/how-to-check-if-a-string-is-a-valid-date
      redirect_to "/menuposrventaxfechats/new", notice: "Debe elegir una fecha de inicio valida. Ej. favor verifiicar si el mes es de 30 o 31 dias." and return
    end

    @dia2 = @dia2.to_date.tomorrow # + 1.day    #como en between simepre empieza al inicio del dia, o sea a la media noche, La fecha final le sumaremos un dia para que seal igual al final del dia elegido, que es igual al inicio del dia posterior al final deseado. O sea, desde inicio de A hasta inicio de C es igual a: Desde inicio de a hasta final de B. (Donde termina B empieza C) ok. Ted. Rails concole. ok.


    #@valor es ventas
    #Defino @objeto_array_ventas para no hacer dos consultas al ActiveRecord de @valor (sum) y de @cantidad_de_tickets_vendidos (count) ok ted.
    @objeto_array_ventas = Jugadalot.between_times(@dia1.to_date , @dia2 ).where(:ticket_id => Ticket.between_times(@dia1.to_date , @dia2 ).where(:user_id => current_user.id , :activo => "si").ids )
   
    @valor = @objeto_array_ventas.sum(:monto) 
    @cantidad_de_tickets_vendidos = @objeto_array_ventas.count

    @ganadores_cuadre = Ticketsganadorest.between_times(@dia1.to_date , @dia2).where(:sucursal => current_user.email.split('@')[0]).sum(:montoacobrar)

    #Tickets pendientes de pago son Todos los tickets ganadores de ese rango de fecha no pagados.sumatoria
    @cantidad_de_tickets_pendiente_de_pago = Ticketsganadorest.between_times(@dia1.to_date , @dia2 ).where(:ticket_id => Ticket.between_times(@dia1.to_date , @dia2 ).where(:user_id => current_user.id , :activo => "si", :ganador => "si", :pago => nil).ids).count

    @dia1 = session[:fecha_venta_dia_1].values.join("-") # para el show dd-mm-aaaa
    @dia2 = session[:fecha_venta_dia_2].values.join("-") # para el show dd-mm-aaaa

   # session[:fecha_venta_dia] = nil
    
    @st = ""
    @font = "|2C" # Tamanio de las letras.

    @data = "" # Hacer un espacion para la separacion del titulo. Estetica del reporte. ok ted.
    @st += "printer.printNormal(POSPrinterConst.PTR_S_RECEIPT, ESC + "  + %Q{"#{@font}"} + " + " +  %Q{ " #{@data}"} + " + LF);"

    @data = "Reporte de Venta:" 
    @st += "printer.printNormal(POSPrinterConst.PTR_S_RECEIPT, ESC + "  + %Q{"#{@font}"} + " + " +  %Q{ " #{@data}"} + " + LF);"

    @data = "" # Hacer un espacion para la separacion del titulo. Estetica del reporte. ok ted.
    @st += "printer.printNormal(POSPrinterConst.PTR_S_RECEIPT, ESC + "  + %Q{"#{@font}"} + " + " +  %Q{ " #{@data}"} + " + LF);"

    @dia1 = session[:fecha_venta_dia_1].values.join("-")
    @dia2 = session[:fecha_venta_dia_2].values.join("-")

    @data = "Desde: " + @dia1.to_s # aqui tiene este valor: @dia = session[:fecha_venta_dia].values.join("-")
    @st += "printer.printNormal(POSPrinterConst.PTR_S_RECEIPT, ESC + "  + %Q{"#{@font}"} + " + " +  %Q{ " #{@data}"} + " + LF);"
    

    @data = "Hasta: " + @dia2.to_s # aqui tiene este valor: @dia = session[:fecha_venta_dia].values.join("-")
    @st += "printer.printNormal(POSPrinterConst.PTR_S_RECEIPT, ESC + "  + %Q{"#{@font}"} + " + " +  %Q{ " #{@data}"} + " + LF);"
    

    @data = "Sucursal: " + current_user.email.split("@")[0].to_s
    @st += "printer.printNormal(POSPrinterConst.PTR_S_RECEIPT, ESC + "  + %Q{"#{@font}"} + " + " +  %Q{ " #{@data}"} + " + LF);"
    
    
    #@data = "Venta: $" + @valor.to_s # number_to_currency(@valor, :unit => "", :delimiter => ",", :precision => 0, :separator => ".")
    
    @data = "Venta: $" + ActionController::Base.helpers.number_to_currency(@valor.to_s, :unit => "", :delimiter => ",", :precision => 0, :separator => ".")
    @st += "printer.printNormal(POSPrinterConst.PTR_S_RECEIPT, ESC + "  + %Q{"#{@font}"} + " + " +  %Q{ " #{@data}"} + " + LF);"

    @data = "" # Hacer un espacion para la separacion del titulo. Estetica del reporte. ok ted.
    @st += "printer.printNormal(POSPrinterConst.PTR_S_RECEIPT, ESC + "  + %Q{"#{@font}"} + " + " +  %Q{ " #{@data}"} + " + LF);"

    @font = "|1C"
    @data = "Consultado el: " + Time.now.strftime("%d/%m/%Y (%H:%M:%S)").to_s 
    @st += "printer.printNormal(POSPrinterConst.PTR_S_RECEIPT, ESC + "  + %Q{"#{@font}"} + " + " +  %Q{ " #{@data}"} + " + LF);"

    @data = "" # Hacer un espacion para la separacion del titulo. Estetica del reporte. ok ted.
    @st += "printer.printNormal(POSPrinterConst.PTR_S_RECEIPT, ESC + "  + %Q{"#{@font}"} + " + " +  %Q{ " #{@data}"} + " + LF);"

    session[:fecha_venta_dia_1] = nil # Limpio la variable para evitar cookie oversize en el cliente.
    session[:fecha_venta_dia_2] = nil # Limpio la variable para evitar cookie oversize en el cliente.
  
    
    # Gererar cadena de impresion de este cuadre para version impresion movil:


                       # @st_movil = ""

                        @st_movil =   "CUADRE DE VENTAS"+ "@@"                        
                        @st_movil +=  "Desde: " +  @dia1.to_s  + "@@"
                        @st_movil +=  "Hasta: " +  @dia2.to_s  + "@@"
                        @st_movil +=  "Sucursal: " + current_user.email.split("@")[0].to_s + "@@"
                        @st_movil += "@@"
                        @st_movil +=  "Total Ventas: $" + ActionController::Base.helpers.number_to_currency(@valor, :unit => "", :delimiter => ",", :precision => 0, :separator => ".") + "@@"
                        @st_movil +=  "[" + @cantidad_de_tickets_vendidos.to_s + " tickets]" + "@@"
                        @st_movil +=  "Total Ganadores: $" +  ActionController::Base.helpers.number_to_currency(@ganadores_cuadre, :unit => "", :delimiter => ",", :precision => 0, :separator => ".") + "@@"
                        @st_movil +=  "Pdte.xPagar(tk): $" +  ActionController::Base.helpers.number_to_currency(@cantidad_de_tickets_pendiente_de_pago, :unit => "", :delimiter => ",", :precision => 0, :separator => ".")  + "@@"
                        @st_movil += "@@"
                        @st_movil +=  "BALACE TOTAL: $" +  ActionController::Base.helpers.number_to_currency((@valor.to_i - @ganadores_cuadre.to_i), :unit => "", :delimiter => ",", :precision => 0, :separator => ".")  + "@@"
                        @st_movil +=  "Impreso: " +  Time.now.strftime("%d/%m/%Y (%H:%M:%S)")  + "@@"
                       

                        #@id_valido_provisional_show_relleno_get_ted = Jugadalot.first.id 
                        session[:st_movil] = @st_movil

                        session[:esperar_ubicacion] = "si"
                        # manejo y registro de ubucacion (session movil debe ser true, ok. entonces manda ubicacion gps el celular)

  end


  def show
  end

  def new
    @menuposrventaxfechat = Menuposrventaxfechat.new
  end

  def edit
  end

  
  def create
    @fecha1 = params.require(:menuposrventaxfechat).permit(:desde) 
    @fecha2 = params.require(:menuposrventaxfechat).permit(:hasta) 
    session[:fecha_venta_dia_1] = @fecha1
    session[:fecha_venta_dia_2] = @fecha2
    redirect_to menuposrventaxfechats_path and return 
  end

  def update
  end

  def destroy
  end

private

def menuposrventaxfechat_params
      params.require(:menuposrventaxfechat).permit!
end

end

