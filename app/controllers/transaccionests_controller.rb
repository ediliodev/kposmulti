class TransaccionestsController < ApplicationController
   http_basic_authenticate_with name: "ventas", password: "456456", except: :index

  skip_before_action :verify_authenticity_token # arduino json old
  before_action :set_transaccionest, only: [:show, :edit, :update, :destroy]
  before_action :index_transaccionest_params_only, only: [:index, :create]


  # GET /transaccionests
  # GET /transaccionests.json
  def index
    #Este link puede ser util en un fitiro si deseamos identificar el cliente por ip:
    #request.remote_ip
    #request.env['HTTP_X_REAL_IP']
    #https://stackoverflow.com/questions/4465476/rails-get-client-ip-address
    
    # Por ahora lo haremos con un serial param enviado por el cliente usando en mismo verbo GET. Para identificar que quien es la peticion. ok. ted.
    @param_serial = index_transaccionest_params_only[:serial] # Extraer el parametro :serial de la petigion GET.
   
    if @param_serial != nil
       @mostrar_vista_web_normal = false # muestro la vista en modo aarduin index con el comando basico ok. ted.  
       @maquina_segun_serial = Maquinat.where(:serial => @param_serial).first   || "no existe"
       if @maquina_segun_serial.id # me aseguro que sea un objeto (con id por su puesto y no otra cosa true)
         @maquina_segun_serial.lastseen = Time.now
          @maquina_segun_serial.save
       end
    end

    if @param_serial == nil || @param_serial.empty? 
       @mostrar_vista_web_normal = true # Estom para mostrar web normal condicion que se revisa en la vista index de esta action
    end

   @transaccionests = Transaccionest.all # Rails refault.
   
   @transaccion_actual_objeto = nil # inicializo variable en nil.

   if @param_serial != nil
     #Solo buscar solicitudes pendientes dentro de los ultimos 5min, las demas del dia y dias anteriores no califican. (para que la maq nos se pase el dia enviando creditos viejos. ok. 5min. solamente.)
     # @tiempo_5min_antes = (Timen.now - 5.minutes)

     @transaccion_actual_objeto = Transaccionest.where(:maquinat_id => (Maquinat.where(:serial => @param_serial).first.id), :status => "pendiente").last # || Transaccionest.first # Dejo el UTC normal de la base de datos, resto 5 min a Time.now, Luego le sumo 4 horas para IGUALAR al timepo UTC, no a mi zona horaria, la cual serial -4GMT (serial restando para igualar a mi zona, pero como voy a comparar coon UTC sumo +4hr e igualo al tiempo(zona horaria) UTC para restar los 5min y comparar ok.)
    
    if @transaccion_actual_objeto == nil
        @transaccion_actual_objeto_no_existe = true # activo flag para que no ponga comandos en la vista de este controlador (index.html) y retorno a la vista, fin de la logica de esta action (def index end) en el controlador. ok. ted.
        return  
    end

    # @fecha_fix_utc = @transaccion_actual_objeto.created_at - 4.hours

     if ( (@transaccion_actual_objeto.created_at ) >  (Time.now  - 1.minutes ) )
     #if ( @fecha_fix_utc >  (Time.now  - 5.minutes ) )
      # @transaccion_actual_comando = @transaccion_actual_objeto.comando #comnado para ese serial, pendiente de ejecutar.
       # ahora actializamos el status de pendiente a Ok. Comando completado.
       @transaccion_actual_objeto.status = "ok"
       @transaccion_actual_objeto.save
    else
       @transaccion_actual_objeto.status = "nulo"
       @transaccion_actual_objeto.save
       @transaccion_actual_objeto.comando = nil # asigno nil para que si ya paso 5 min, else devuleve este objeo en la vista del index con el atrubito comando en nil. arduino no ejecuta comando de creditos viejos ok.
    end

   else

     #  redirect_to "/transaccionests/new", notice: "No se pudo recibir el param serial de la peticion. Incompleta." and return  
   
   end
   #Comando de la ultima transaccion pendiente de ese cliente de menos de 5 min.
   
   


  end

  # GET /transaccionests/1
  # GET /transaccionests/1.json
  def show
  end

  # GET /transaccionests/new
  def new
    @transaccionest = Transaccionest.new
    @lastly_transaccionests = Transaccionest.today.last(10).reverse
    @lastly_postransaccionests = Postransaccionest.today.last(10).reverse
    @kit_maquinats = Maquinat.where(:activa => "si")
    @kit_maquinats_verde = Maquinat.where("updated_at > ?", (Time.now - 30.seconds)).ids # where(:updated_at > ( (Time.now - 4.hours) - 300.seconds) ) 
    @sucursal =  Localidadt.last.sucursal # Super Games & Sports # 01 ( La sucursal se registra detalla ok.)

     #@neto_hoy = Transaccionest.all.sum(:cantidad).to_i / 100 # provisional, hay que agragar la gema by_day
 
     #CONSULTA RAPIDA DEL BALANCE ACTUAL DE HOY:
     @total_in = Transaccionest.by_day(Date.today).where( :tipotransaccion => "credito", :status => "ok").sum(:cantidad)  
     @total_out = Postransaccionest.by_day(Date.today).sum(:cantidad)  

     @neto_hoy = @total_in.to_i - @total_out.to_i # PARA MOSTRAR LA VENTA DEL DIA ACTUAL EN LA PANTALLE PRINCIPAL OK.

  end

  # GET /transaccionests/1/edit
  def edit
  end

  # POST /transaccionests
  # POST /transaccionests.json
  def create

    @transaccionest = Transaccionest.new(transaccionest_params)

   #Seccion para verificar que la maq este verde antes de enviarle el credito. Peticion Nestor Client. Tambien se puede definir en una funcion callback rails, before action rails ok. ted. 
   @maquinas_activas_verde = Maquinat.where("updated_at > ?", (Time.now - 30.seconds)).ids # where(:updated_at > ( (Time.now - 4.hours) - 300.seconds) ) 
  
   if (not @maquinas_activas_verde.include? @transaccionest.maquinat_id)
    redirect_to "/transaccionests/new", notice: "X.Credito no enviado. MQ en ROJO sin conexion. Favor verificar." and return    

   end


   # if @transaccionest.tipotransaccion == nil
  #    @transaccionest.tipotransaccion = "credito"
  #  end

    #Evaluar entrada y ajustar/cambiar parametros segun sea necesario:
    #@transaccionest.status = "pendiente"

    #@transaccionest
    # Transaccionest.where(:maquina_id => Maquinat.where(:serial=> params_serial).id).last pending
   # @param_serial = transaccionest_params[:serial] # Extraer el parametro :serial
#    @param_serial = @transaccionest.tipotransaccion #provisional mando el serial en esta campo. #index_transaccionest_params_only[:serial]
    
#    if ( @transaccionest.maquinat_id.nil? ) # != 1

    #  @transaccionest.maquinat_id = Maquinat.where(:serial=> @param_serial).last.id
      # @transaccionest.maquinat_id = 1
    #  @transaccionest.tipotransaccion = "debito" # provisiona

 #   end
    
   

    respond_to do |format|
      if @transaccionest.save
        format.html { redirect_to new_transaccionest_path, notice: 'Procesando ok...' }
        format.json { render :show, status: :created, location: @transaccionest }
      else
         redirect_to "/transaccionests/new" and return  # forzo el redireccionamiento en caso de no salvar(guardarse la entrada) de este objeto por razon de que si hacen click en enviar sin la cantidad a acreditar no afecte al programa ok. ted.
        #format.html { render :new }
        #format.json { render json: @transaccionest.errors, status: :unprocessable_entity }

      end
    end
  end

  # PATCH/PUT /transaccionests/1
  # PATCH/PUT /transaccionests/1.json
  def update
    respond_to do |format|
      if @transaccionest.update(transaccionest_params)
        format.html { redirect_to @transaccionest, notice: 'Transaccionest was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaccionest }
      else
        format.html { render :edit }
        format.json { render json: @transaccionest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transaccionests/1
  # DELETE /transaccionests/1.json
  def destroy
   # @transaccionest.destroy # NO PERMIITPO POR DESDE PORTAL WEB. POLITICAS DE SEGURIRAD. CONTACT ADMIN FOR THIS. OK.
    respond_to do |format|
      format.html { redirect_to transaccionests_url, notice: 'NOT ALLOWED, SECURITY. INCIDENT REPORT. CONTACT ADMIN.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaccionest
      @transaccionest = Transaccionest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaccionest_params
     # params.require(:transaccionest).permit(:maquinat_id, :tipotransaccion, :cantidad, :comando, :status)
      params.require(:transaccionest).permit(:maquinat_id, :tipotransaccion, :cantidad, :comando, :status)
    end
    #HACER UN BACKUP DE ESTE ARCHIO Y PROBAR DEMAS, DE LO CONTRARIO, SOLUCION CREAR DOS SCAFFOLDS UNOA PARA ARDUINO POST Y EL OTRO PARA LA PC CREDITS Y DEMAS ? OJO EL GET RESOURCE ARDUINO.

    def index_transaccionest_params_only
      params.permit(:serial) # Ted ok para recibir serial en GET params ok.
    end


end



#http://127.0.0.1:3000/jugadalots?cliente_id=c8ea980cf4aa971b&tipo_cliente=movil

#curl http://www.smsggglobal.com/http-api.php?action=sendsms&user=asda&password=123123&&from=123123&to=1232&text=adsdad
##curl -d "maquinat=1&tipotransaccion=credit&cantidad=25&status=pendiente" 127.0.0.1:3000/transaccionests/new


##curl http://127.0.0.1:3000/transaccionests/new?action=transaccionests&maquinat=1&tipotransaccion=credit&cantidad=25&status=pendiente

##http://127.0.0.1:3000/transaccionests/new

##curl -X POST -d "backToBasics=for the win" http://localhost:3000/curl_example



##TIPOMAQUINA DESCRIPCION

#COSAS PENDIENTES:
# REPORTE DE VENTAS Y EL CUADRE (USAR LA GEMA buy_day ?) copiar resourse de babylot ejemplo
# menu o lista de links para configuracion de maquinats, sucursal, 
# en la consulta de reporte mostrar las transacciones tambiae (caso de chek creditos no lleguen etc,,) ej. reporte: TOTAL ACREDITADO: TOTAL PAGADO, TOTAL NETO:  y poner debajo la tabla de transacciones?, manejar la impresion. klk. Web. provisional. ok ted. better. sin la tabla?  <div id=imprimir_cuadre> js mas o menos. 
#
#
#
#
# Reportes - +Maquinas - Sucursal


# EN EL REPORTE IMPRESION DE CUADRE IMPRIMIR LA FECHA DE CONSULTA. MUY IMPORTANTE. DATETIME RANGE REPORT. OK. TED.
#CONSIDERAR IMPRIMRI EL TICKET CUANDOD E ENVIE CREDITOS O SE PAGUE. ESTO ES POSIBLE CON UN PRINTLINK EN LA LISTA DE LA TABLA DE TRANSACCIONES. KLK/? RPINV DIV JAVASCRIPT DOCUMENT? (USAR UNA VARIABLE STRING CON TODO EN UN HTML TAG QUE CONTENGA LA DATA GENEREADA EN RAILS PARA IMPRIMIRSE POR CADA LINEA DE TX. OK. LIKE GUARDAR IMPRESION EN LA TABLA +/- O ENVIARLA DIRECTAMENTE AL DOCUMENTO.)
#AJAX KLK MONITOR MAQUINAS <DIV> Y DEMAS.
#CONSIDERAR QUE NO SE REALICEN TRANSACCIONES (SEND CREDITS) EN BLANCO OJO. OK. TED, VALIDAR BOTON EVIAR CREDITO.