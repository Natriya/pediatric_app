class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name, :null => false
      t.string :surname, :null => false
      t.string :sex, :null => false
      t.date :birthday
      t.string :cell_phone_number
      t.string :email
      
      # Mother|Father|Tutor
      t.string :type
      
      # Address
      t.integer :address_id
      
      # Company
      t.integer :company_id
      t.integer :company_person_identification
      t.string :occupation

      t.timestamps
    end
  end
end
