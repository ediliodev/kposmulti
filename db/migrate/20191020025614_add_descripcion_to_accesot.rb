class AddDescripcionToAccesot < ActiveRecord::Migration[5.1]
  def change
    add_column :accesots, :descripcion, :string
  end
end
