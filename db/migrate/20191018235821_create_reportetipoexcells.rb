class CreateReportetipoexcells < ActiveRecord::Migration[5.1]
  def change
    create_table :reportetipoexcells do |t|
      t.date :fecha
      t.string :in
      t.string :out
      t.string :net

      t.timestamps
    end
  end
end
