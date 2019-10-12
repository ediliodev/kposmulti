class CreateReportets < ActiveRecord::Migration[5.1]
  def change
    create_table :reportets do |t|
      t.date :desde
      t.date :hasta

      t.timestamps
    end
  end
end
