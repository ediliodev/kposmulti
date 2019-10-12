class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  protect_from_forgery unless: -> { request.format.json? }  # agregado de este link ok ted: http://arduinoetcetera.blogspot.com/2017/04/example-ruby-on-rails-arduino-project.html
 # protect_from_forgery unless: -> { request.format.html? }
end


#curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"temperature":0, "humidity":0}' http://localhost:3000/measures 