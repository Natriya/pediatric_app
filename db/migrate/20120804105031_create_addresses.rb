class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.text :address
      t.string :phone_number

      t.timestamps
    end
  end
end
