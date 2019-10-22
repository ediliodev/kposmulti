class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  protect_from_forgery unless: -> { request.format.json? }  # agregado de este link ok ted: http://arduinoetcetera.blogspot.com/2017/04/example-ruby-on-rails-arduino-project.html
 # protect_from_forgery unless: -> { request.format.html? }


#definicion general de los siguientes metodos para ser accesados o invocados posteriormente por ted desde cualquier controlador que herede de aqui, ok ted.

def registro_login_admin

  #consierar que no si no es nadie (cualquier cosa diferente de supervisor, admin, ventas, por ejemplo nil u otro valor desconocido, ok ted.) sea ventas el acceso.
  if( (session[:current_user].to_s != "ventas") && ( session[:current_user].to_s != "supervisor") && (session[:current_user].to_s != "admin") )
    session[:current_user] = "admin"
    @accesot = Accesot.new
    @accesot.usuario = "admin"
    @accesot.tipoacceso = "login"
    @accesot.fechayhora = Time.now
    @accesot.ip = request.env['action_dispatch.remote_ip'].to_s # registro la ip desde donde se hace el request. ok.
    @accesot.save
     
   end 

    if( (session[:current_user].to_s == "ventas") || (session[:current_user].to_s == "supervisor") )

      #registrar LOGOUT de admin o de supervisor, dependiendo valor de la session ok:       
      @accesot = Accesot.new
      @accesot.usuario = session[:current_user].to_s # selecciono el usuario a hacer logout. ok. (puede contener "admin" o "supervisor" solamente porque esta dentro del if condition ok ted.)
      @accesot.tipoacceso = "logout"
      @accesot.fechayhora = Time.now
      @accesot.ip = request.env['action_dispatch.remote_ip'].to_s # registro la ip desde donde se hace el request. ok.
      @accesot.save

      #registrar login ventas:
      session[:current_user] = "admin"
      @accesot = Accesot.new
      @accesot.usuario = "admin"
      @accesot.tipoacceso = "login"
      @accesot.fechayhora = Time.now
      @accesot.ip = request.env['action_dispatch.remote_ip'].to_s # registro la ip desde donde se hace el request. ok.
      @accesot.save

      #crear el scaffold de este modelo.
      #ver lo del after_filter action ok.
      #probarlo.
      #continuar lo mismo pero para admin, en los controladores requeridos.
       
   end 

 end #fin de la funcion  registro_login_admin


end

#Error: This POS is Not authorized, please contact support to activate it. That's a simple solution.!

# curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"temperature":0, "humidity":0}' http://localhost:3000/measures 