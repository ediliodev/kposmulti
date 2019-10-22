class ReportetsController < ApplicationController
  before_action :set_reportet, only: [:show, :edit, :update, :destroy]

  # GET /reportets
  # GET /reportets.json
  def index
    #@reportets = Reportet.all
    
    @day1 = session[:fecha_venta_dia_1]
    @day2 = session[:fecha_venta_dia_2]

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

   # @dia2 = @dia2.to_date.tomorrow # OJO YA NO ES NECESARIO ESTO. OK. SI VAS A USAR BETWEEN TIMES EN LA GEMA BY_DAY, YA QUE ELLA SOLA AUTOMATICAMENTE ELIGE EL RANGO FINAL DEL DIA, EJ. SI ES EL DIA (1RO DE OCTUBRE) 2019-10-01   BETWENN HARA EL OFFSET DEL SEGUND DIA AUTOMATICO, ENTONCES SE DEBE DE PONER ASI Modelo.beetween_times("2019-10-01".to_date, "2019-10-01".to_date ) => del 01 ocubre a las 00:00:00 horas( + GMT si esta configurado Time Zone en rails, en nuestro caso si 4 horas, hasta el mismo 01 oct a las 23:59:59 + el GMT) ok ted. probar en Rails c


    @dia1 = @dia1.to_date

    #@valor es ventas
    #Defino @objeto_array_ventas para no hacer dos consultas al ActiveRecord de @valor (sum) y de @cantidad_de_tickets_vendidos (count) ok ted.
  #  @objeto_array_ventas = Jugadalot.between_times(@dia1.to_date , @dia2 ).where(:ticket_id => Ticket.between_times(@dia1.to_date , @dia2 ).where(:user_id => current_user.id , :activo => "si").ids )
   
   # @valor = @objeto_array_ventas.sum(:monto) 
   # @cantidad_de_tickets_vendidos = @objeto_array_ventas.count



  
  #  @ganadores_cuadre = Ticketsganadorest.between_times(@dia1.to_date , @dia2).where(:sucursal => current_user.email.split('@')[0]).sum(:montoacobrar)

    #Tickets pendientes de pago son Todos los tickets ganadores de ese rango de fecha no pagados.sumatoria
  #  @cantidad_de_tickets_pendiente_de_pago = Ticketsganadorest.between_times(@dia1.to_date , @dia2 ).where(:ticket_id => Ticket.between_times(@dia1.to_date , @dia2 ).where(:user_id => current_user.id , :activo => "si", :ganador => "si", :pago => nil).ids).count

#loop para reporte resumido dia x dia like excell, (usaremos las mismas variables, solo haremos un loop con la logica de abajo. ok. ted. Esto para prueba generar reportes like nestor excell ok.)

@veces = (@day2.values.join("-").to_date - @day1.values.join("-").to_date ).to_i  # devuelve un muero racional que dividido da un numero entero correspondiente a la cantidad de dias de la resta realizada.

# @veces  contiene la cantidad de dias que hay entre el rango de fecha seleccionado. Esto para sacar el reporte diaxdia. ok.

#@veces.times do |dia|
#  @total_in =  Transaccionest.between_times(@dia1.to_date, @dia2 + dia.to_i).where(:tipotransaccion => "credito", :status => "ok").sum(:cantidad)
#  @total_out =  Postransaccionest.between_times(@dia1.to_date, @dia2).sum(:cantidad)
#
#  @total_net = @total_in.to_i - @total_out.to_i
#
#end


# Me insteresa limpiar la tabla de reportes rapidamente, uso delete en ves de destroy porque obvia el dependent destroy model relations. ojo usar con responsabilidad. ok. este modelo no tiene dependencia alga de otro. ok.
@limpiar_tabla_reporte = Reportetipoexcell.delete_all #  Returns the number of rows affected.  link: https://apidock.com/rails/ActiveRecord/Base/delete_all/class

if (  (@veces > 1)  && ( session[:reporte].to_s != "supervisor_ok") && (session[:reporte].to_s != "admin_ok") )
      redirect_to "/transaccionests/new", notice: "Puedes consultar ventas del dia actual y del anterior, para otro tipo de reportes favor contactar a su supervisor." and return  

  #render "klk"
#  http_basic_authenticate_with name: "ventas", password: "456456", except: :index

end

(@veces + 1).times do |offset| # para incluir el ultimo dia en la consulta ej. 1-18 oct solo salen 17 dias, el 18avo dia se suma en el loop ara que lo corra al final ok ted.
#Reciclo esta parte del codigo de abajo, esto solo para provecharlo y utilizar la logica para implementarla en el reporter anidado del reporte excell. ok. ted.
  @total_in =  Transaccionest.between_times(@dia1.to_date + offset, (@dia1.to_date + offset)).where(:tipotransaccion => "credito", :status => "ok").sum(:cantidad)
  @total_out =  Postransaccionest.between_times(@dia1.to_date + offset,( @dia1.to_date + offset.days) ).sum(:cantidad)
  @total_net = @total_in.to_i - @total_out.to_i

  @entrada_objeto = Reportetipoexcell.new
  @entrada_objeto.fecha = @dia1.to_date + offset
  @entrada_objeto.in = @total_in
  @entrada_objeto.out = @total_out
  @entrada_objeto.net = @total_net
  @entrada_objeto.save

end
@veces +=1 # esto para ell viwe solamente del counter 0..veces ok ted. no altera el ciclo de arriba ok.

@reporte_tipo_excell = Reportetipoexcell.all # Seleccion todos los valores dia x dia del reporte tipo excell. Esto para ser mostrado en la vista.



@total_in =  Transaccionest.between_times((@dia1.to_date ), (@dia2.to_date )).where(:tipotransaccion => "credito", :status => "ok").sum(:cantidad)
@total_out =  Postransaccionest.between_times((@dia1.to_date), (@dia2.to_date)).sum(:cantidad)

@total_net = @total_in.to_i - @total_out.to_i

@d1 = @dia1
@d2 = @dia2

@dia2 = @dia2.to_date # no borrar esto para setear formato de esta variable al tipo to_date para la logica de abajo en adelante y no tener que modificarla una a una debajo. ok. ted.

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
     #session[:klk] = params.require(:reportet).permit(:password).values[0]
    @pwd_sup = params.require(:reportet).permit(:password).values[0].to_s
    if @pwd_sup == "abc65535"
      session[:reporte] = "supervisor_ok"
      session[:klk] = @pwd_sup
      @accesot = Accesot.new
      @accesot.usuario = "supervisor"
      @accesot.tipoacceso = "login"
      @accesot.fechayhora = Time.now
      @accesot.ip = request.env['action_dispatch.remote_ip'].to_s # registro la ip desde donde se hace el request. ok.
      @accesot.descripcion = "Login consulta reporte de ventas"
      @accesot.save
    end


    if @pwd_sup == "64738"
      session[:reporte] = "admin_ok"
       session[:klk] =  session[:reporte] #@pwd_sup
       @accesot = Accesot.new
       @accesot.usuario = "admin"
       @accesot.tipoacceso = "login"
       @accesot.fechayhora = Time.now
       @accesot.ip = request.env['action_dispatch.remote_ip'].to_s # registro la ip desde donde se hace el request. ok.
       @accesot.descripcion = "Login consulta reporte de ventas"
       @accesot.save
    end

    

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
      params.require(:reportet).permit(:desde, :hasta, :password)
    end
end



