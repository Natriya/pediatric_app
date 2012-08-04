class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :name, :null => false
      t.text :address
      t.string :phone_number
      t.string :email
      t.text :other
      t.boolean :admin, :default => false
      
      t.string :encrypted_password
      t.string :salt

      t.timestamps
    end
    
    add_index :users, :username, :unique => true
  end
end
