class Address < ActiveRecord::Base
  attr_accessible :address, :phone_number
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

