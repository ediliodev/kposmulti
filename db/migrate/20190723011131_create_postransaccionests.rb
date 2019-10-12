class CreatePostransaccionests < ActiveRecord::Migration[5.1]
  def change
    create_table :postransaccionests do |t|
      t.string :cantidad
      t.string :serial

      t.timestamps
    end
  end
end
