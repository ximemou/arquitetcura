class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.json :user
      t.string :role
      t.timestamps
    end
  end
end
