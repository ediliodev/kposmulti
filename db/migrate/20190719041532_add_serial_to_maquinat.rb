class AddSerialToMaquinat < ActiveRecord::Migration[5.1]
  def change
    add_column :maquinats, :serial, :string
  end
end
