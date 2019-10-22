class CreateAccesots < ActiveRecord::Migration[5.1]
  def change
    create_table :accesots do |t|
      t.string :usuario
      t.string :tipoacceso
      t.datetime :fechayhora
      t.string :ip

      t.timestamps
    end
  end
end
