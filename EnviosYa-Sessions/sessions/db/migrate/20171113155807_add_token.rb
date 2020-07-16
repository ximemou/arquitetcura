class AddToken < ActiveRecord::Migration[5.1]
  def change
  	add_column :sessions, :authentication_token, :text
    add_column :sessions, :authentication_token_created_at, :datetime

    add_index :sessions, :authentication_token, unique: true
  end
end
