class Person < ActiveRecord::Base
  attr_accessible :address, :birthday, :cell_phone_number, :email, :name, :sex_male, :surname

  belongs_to :father, :class_name => 'Person'
  belongs_to :mother, :class_name => 'Person'
  belongs_to :tutor, :class_name => 'Person'
  has_many :children_of_father, :class_name => 'Person', :foreign_key => 'father_id'
  has_many :children_of_mother, :class_name => 'Person', :foreign_key => 'mother_id'
  has_many :children_of_tutor, :class_name => 'Person', :foreign_key => 'tutor_id'
  def children
     children_of_mother + children_of_father
  end

end
# == Schema Information
#
# Table name: people
#
#  id                :integer         not null, primary key
#  name              :string(255)     not null
#  surname           :string(255)     not null
#  sex_male          :boolean         default(FALSE)
#  birthday          :date
#  address           :text
#  cell_phone_number :string(255)
#  email             :string(255)
#  father_id         :integer
#  mother_id         :integer
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

