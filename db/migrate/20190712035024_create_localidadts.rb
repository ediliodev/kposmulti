class CreateLocalidadts < ActiveRecord::Migration[5.1]
  def change
    create_table :localidadts do |t|
      t.string :consorcio
      t.string :sucursal
      t.string :direccion

      t.timestamps
    end
  end
end
