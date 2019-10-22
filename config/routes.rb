Rails.application.routes.draw do
  resources :reportetipoexcells
  resources :accesots
  resources :mixtransaccionests
  resources :reportets
  resources :postransaccionests
  resources :transaccionests
  resources :maquinats
  resources :tipomaquinats
  resources :localidadts

  root to: 'transaccionests#new'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
