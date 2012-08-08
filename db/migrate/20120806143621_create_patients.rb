class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :name, :null => false 
      t.string :surname, :null => false
      t.string :gender, :null => false
      t.date :birthday
      t.date :next_appointment_date
      t.integer :mother_id
      t.integer :father_id
      t.integer :tutor_id

      t.timestamps
    end
  end
end
