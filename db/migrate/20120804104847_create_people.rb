class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name, :null => false
      t.string :surname, :null => false
      t.string :sex, :null => false
      t.date :birthday
      t.text :address
      t.string :cell_phone_number
      t.string :email
      
      t.integer :father_id 
      t.integer :mother_id 
      t.integer :tutor_id 

      t.timestamps
    end
  end
end
