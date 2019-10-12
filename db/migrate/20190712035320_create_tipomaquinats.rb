class CreateTipomaquinats < ActiveRecord::Migration[5.1]
  def change
    create_table :tipomaquinats do |t|
      t.string :tipomaquina
      t.string :descripcion

      t.timestamps
    end
  end
end
