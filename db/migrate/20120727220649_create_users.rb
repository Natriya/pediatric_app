class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :name
      t.text :address
      t.string :phone_number
      t.string :email
      t.text :other
      t.boolean :admin
      t.string :encrypted_password
      t.string :salt

      t.timestamps
    end
  end
    
  def self.down
    drop_table :users
  end
end
