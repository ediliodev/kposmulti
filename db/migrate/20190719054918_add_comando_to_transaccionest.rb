class AddComandoToTransaccionest < ActiveRecord::Migration[5.1]
  def change
    add_column :transaccionests, :comando, :string
  end
end
