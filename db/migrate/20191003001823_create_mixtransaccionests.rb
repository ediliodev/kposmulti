class CreateMixtransaccionests < ActiveRecord::Migration[5.1]
  def change
    create_table :mixtransaccionests do |t|
      t.references :maquinat, foreign_key: true
      t.string :tipotransaccion
      t.string :cantidad
      t.string :comando
      t.string :status
      t.string :descripcion

      t.timestamps
    end
  end
end
