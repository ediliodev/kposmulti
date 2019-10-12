class CreateMaquinats < ActiveRecord::Migration[5.1]
  def change
    create_table :maquinats do |t|
      t.references :tipomaquinat, foreign_key: true
      t.string :descripcion

      t.timestamps
    end
  end
end
