class TransaccionestsController < ApplicationController
  http_basic_authenticate_with name: "ventas", password: "456456", except: :index


#Elvalua tipo de usuario loggeado y redirecccionar apropiadamente:
#ventas => a ventas
#supervisor =>  a reportes y session[etc..] maquinas_activar para desactivar limites de rango de fechas de los reportes
#admin => maquinats y futuro cambio de contrasenas por modelos. ok.
#if session[:current_user].to_s == "supervisor"
 # redirect_to "/reportets/new"  and return  
#end


  skip_before_action :verify_authenticity_token # arduino json old
  before_action :set_transaccionest, only: [:show, :edit, :update, :destroy]
  before_action :index_transaccionest_params_only, only: [:index, :create]
  before_action :validar_hw_punto_de_venta, only: [:index, :new, :create]
  after_action :registro_login_ventas, only: [:index, :new] # metodo definido en ApplicationController.rb para poderlo llamar en cualquier controlador. ok ted. link:https://stackoverflow.com/questions/35588995/rails-call-same-after-action-method-from-different-controllers
  
  @hw_equipo_no_autorizado = false # variable globar de control del hw server (anticlone) que se modifica en el before_action y en el index ok
  # GET /transaccionests
  # GET /transaccionests.json
  def index


    #@accesot = Accesot.new
    #@accesot.usuario = "ventas"
    #@accesot.tipoacceso = "login"
    #@accesot.fechayhora = Time.now
    #@accesot.ip = request.env['action_dispatch.remote_ip'].to_s # registro la ip desde donde se hace el request. ok.
    #@accesot.save

   # registro_login_ventas
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
    
    if (@transaccion_actual_objeto == nil  || @hw_equipo_no_autorizado == true ) # evito enviar creditos desde el web server. Esto es si intentan act la bdatos con un cash pero desde el rails app server la logica de este controlador no lo va a enviar al arduino en la vista (el comando del cash). puede que se sume en la venta pero no llega, porque no esta autorizado ese PoS. posible intento de clonar. ok ted. (La parte de la logica de la variable hw_equipo_no_autorizado ok.)
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
   
   #registro_login_ventas


  end

  # GET /transaccionests/1
  # GET /transaccionests/1.json
  def show
  end

  # GET /transaccionests/new
  def new
    registro_login_ventas

   #registro_login_ventas
   # acc = Accesot.new #Accesot.new
   # acc.save

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

#probar salida del System call
# @salida_system = system("ls")
#esto de abajo sacado de este link: (respuesta #60 ok ted), link: https://stackoverflow.com/questions/690151/getting-output-of-system-calls-in-ruby
@salida_system = %x[cat /sys/devices/virtual/dmi/id/uevent ] #Info gral.
@salida_system  << "  " + %x[lsblk --nodeps -o serial ] 
@salida_system << "  " + %x[ifconfig | grep HWaddr ] 


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


def validar_hw_punto_de_venta
  # variable (string constante) que contiene la informacion del hw pos a instalar el sw.
  hw_pos_details = "MODALIAS=dmi:bvnInsyde:bvrF.14:bd09/18/2012:svnHewlett-Packard:pnHPPaviliong6NotebookPC:pvr0889110002305910000620100:rvnHewlett-Packard:rn1849:rvr57.2E:cvnHewlett-Packard:ct10:cvrChassisVersion: SERIAL SDC3621663 J3E20082H3DJUA eno1 Link encap:Ethernet HWaddr 84:34:97:71:f7:5c wlo1 Link encap:Ethernet HWaddr 74:e5:43:86:00:20 "

  salida_system_hw_info = %x[cat /sys/devices/virtual/dmi/id/uevent ] #Info gral.
  salida_system_hw_info  << "  " + %x[lsblk --nodeps -o serial ] 
  salida_system_hw_info << "  " + %x[ifconfig | grep HWaddr ] 
  #salida_system_hw_info = "klk"

  id_registrado = hw_pos_details = hw_pos_details.split(" ").join("") # Eliminar espacios para la comparacion ID_REGISTRADO
  id_a_validar = salida_system_hw_info = salida_system_hw_info.to_s.split(" ").join("") # Eliminar espacios para la comparacion ID_A_VERIFICAR
  
  #PROVSIONAL TO CONTINUE DEVELOPING:
  id_a_validar = id_registrado

  if(id_registrado.to_s == id_a_validar.to_s)
    true # ok retorna normal al codigo, el hw es el REGISTRADO, devuelto true por convencion. ok.
    @salida_static = "Lic. Activa." # No necesario por ahora, este tag lo quitamos del view new.thml ok ted. era solo para fines de prueba. dejar por orientacion solamente. ok.
    @hw_equipo_no_autorizado = false # solo para estar seguro. flag desactivao, arduino va a recibir html credito. 
  else
    @hw_equipo_no_autorizado = true # activo flag para que el arduino no reciba el comando de cash en hw no autorizado. ok.
    #No es el HW REGISTRADO:
   # respond_to do |format|
   #   format.html { redirect_to new_reportet_path, notice: 'NOT ALLOWED, MUST ACTIVATED POS. PLEASE CONTACT SUPPORT FOR SOLUTION. INCIDENT REPORT. CONTACT ADMIN.' }
   #   format.json { head :no_content }

    #@salida_static = hw_pos_details
    @salida_static1 = "EQUIPO NO AUTORIZADO PARA LA VENTA. VERIFICAR SU LICENCIA." # salida_system_hw_info
    @salida_static2 = "INCIDENTE SERA REPORTADO." # salida_system_hw_info
    @salida_static3 = "CONTACTE A LA CENTRAL PARA SU SOLUCION." # salida_system_hw_info
    
    #end

  end # fin del if contdition


 end # fin de la funcion validar_hw_punto_de_venta


#ESTO YO LO VOY A TRASLADAR A LA CLASE PRINCIPAL APPLICATIONCONTROLLER.RB PARA PODERLO ACCESAR DESDE CUALQUIER CONTROLADOR DEFINIDO POSTERIORMENTE, OK TED. 
 def registro_login_ventas

  #consierar que no si no es nadie (cualquier cosa diferente de supervisor, admin, ventas, por ejemplo nil u otro valor desconocido, ok ted.) sea ventas el acceso.
  if( (session[:current_user].to_s != "ventas") && ( session[:current_user].to_s != "supervisor") && (session[:current_user].to_s != "admin") )
    session[:current_user] = "ventas"
    @accesot = Accesot.new
    @accesot.usuario = "ventas"
    @accesot.tipoacceso = "login"
    @accesot.fechayhora = Time.now
    @accesot.ip = request.env['action_dispatch.remote_ip'].to_s # registro la ip desde donde se hace el request. ok.
    @accesot.save
     
   end 

    if( (session[:current_user].to_s == "admin") || (session[:current_user].to_s == "supervisor") )

      #registrar LOGOUT de admin o de supervisor, dependiendo valor de la session ok:       
      @accesot = Accesot.new
      @accesot.usuario = session[:current_user].to_s # selecciono el usuario a hacer logout. ok. (puede contener "admin" o "supervisor" solamente porque esta dentro del if condition ok ted.)
      @accesot.tipoacceso = "logout"
      @accesot.fechayhora = Time.now
      @accesot.ip = request.env['action_dispatch.remote_ip'].to_s # registro la ip desde donde se hace el request. ok.
      @accesot.save

      #registrar login ventas:
      session[:current_user] = "ventas"
      @accesot = Accesot.new
      @accesot.usuario = "ventas"
      @accesot.tipoacceso = "login"
      @accesot.fechayhora = Time.now
      @accesot.ip = request.env['action_dispatch.remote_ip'].to_s # registro la ip desde donde se hace el request. ok.
      @accesot.save

      #crear el scaffold de este modelo.
      #ver lo del after_filter action ok.
      #probarlo.
      #continuar lo mismo pero para admin, en los controladores requeridos.
       
   end 

  # if session[:current_user] == nil, asignar "ventas" a session[:current_user] y registrar nuevo login
  # if session[:current_user] == admin, asignar "ventas" a session[:current_user] y registrar nuevo login de usuario ventas y registrar como salida de usuario admin.
  # if session[:current_user] == supervisor, asignar "ventas" a session[:current_user] y registrar nuevo login de usuario ventas y registrar como salida de usuario supervisor.
  # if session[:current_user] == ventas, no hacer nada, ya estaba  logeado ok.
  # if session[:current_user] != admin, supervisor, ventas, asignar "ventas" a session[:current_user] y registrar nuevo login usuario ventas.



 end # fin de la funcion registro_login_ventas


end # fin de la clase TransaccionestsController ok.



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