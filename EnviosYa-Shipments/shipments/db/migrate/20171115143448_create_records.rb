class CreateRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :records do |t|
  	t.json "area"
    t.string "kgCost"
      t.timestamps
    end
  end
end
