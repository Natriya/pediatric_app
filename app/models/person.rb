class Person < ActiveRecord::Base
  attr_accessible :address, :birthday, :cell_phone_number, :email, :name, :sex_male, :surname
end
