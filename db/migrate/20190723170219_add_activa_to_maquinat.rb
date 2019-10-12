class AddActivaToMaquinat < ActiveRecord::Migration[5.1]
  def change
    add_column :maquinats, :activa, :string
  end
end
