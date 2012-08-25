class Address < ActiveRecord::Base
  attr_accessible :address, :phone_number
  
  ADDRESS_ENUM = %w[Adresse1 Adresse2 Adresse3]
end
# == Schema Information
#
# Table name: addresses
#
#  id           :integer         not null, primary key
#  address      :text            not null
#  phone_number :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

