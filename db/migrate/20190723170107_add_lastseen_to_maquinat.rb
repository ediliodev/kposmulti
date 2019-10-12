class AddLastseenToMaquinat < ActiveRecord::Migration[5.1]
  def change
    add_column :maquinats, :lastseen, :datetime
  end
end
