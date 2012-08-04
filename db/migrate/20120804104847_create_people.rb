class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :surname
      t.boolean :sex_male
      t.date :birthday
      t.text :address
      t.string :cell_phone_number
      t.string :email

      t.timestamps
    end
  end
end
