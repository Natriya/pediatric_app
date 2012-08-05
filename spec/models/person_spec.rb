require 'spec_helper'

describe Person do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: people
#
#  id                :integer         not null, primary key
#  name              :string(255)     not null
#  surname           :string(255)     not null
#  sex               :string(255)     not null
#  birthday          :date
#  address           :text
#  cell_phone_number :string(255)
#  email             :string(255)
#  father_id         :integer
#  mother_id         :integer
#  tutor_id          :integer
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

