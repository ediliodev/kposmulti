class CreateTransaccionests < ActiveRecord::Migration[5.1]
  def change
    create_table :transaccionests do |t|
      t.references :maquinat, foreign_key: true
      t.string :tipotransaccion
      t.string :cantidad
      t.string :status

      t.timestamps
    end
  end
end
