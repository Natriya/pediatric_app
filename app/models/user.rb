class User < ActiveRecord::Base
  attr_accessible :address, :admin, :email, :encrypted_password, :name, :other, :phone_number, :salt, :username
end
