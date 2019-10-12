class Transaccionest < ApplicationRecord
  belongs_to :maquinat
  #validates: :tipotransaccion, :presence => true, :inclusion => { :in => ['credit','debit','bonus'] }, :message => "Only 'credit', 'debit' or 'bonus' for this field"
  validates_inclusion_of :tipotransaccion, :in => ['credito','debito','comando', 'devolucion'], :on => [:create, :edit], :message => "Valor no incluido en la lista de este campo. X. field"

  #provisional validar cantidad no sea vacia ok ted:
  validates_presence_of :cantidad, :on => :create, :message => "Debes ingresar una cantidad"
  #validates_inclusion_of :tipotransaccion, :in => ['credito','debito','comando', 'devolucion'], :on => :create, :message => "Valor no incluido en la lista de este campo. X. field"
end
