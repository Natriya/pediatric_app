class Person < ActiveRecord::Base
  attr_accessible :address_id, :birthday, :cell_phone_number, :email, :name, :sex, :surname
  attr_writer :current_step

  belongs_to :father, :class_name => 'Person'
  belongs_to :mother, :class_name => 'Person'
  belongs_to :tutor, :class_name => 'Person'
  has_many :children_of_father, :class_name => 'Person', :foreign_key => 'father_id'
  has_many :children_of_mother, :class_name => 'Person', :foreign_key => 'mother_id'
  has_many :children_of_tutor, :class_name => 'Person', :foreign_key => 'tutor_id'
  
  belongs_to :address
  
  
  validates :name, :surname, :presence => true
  validates :sex, :inclusion => { :in => %w(M F) }
  
  
  
  def children
     children_of_mother + children_of_father + children_of_tutor
  end
  
  
  #### Steps Wizard Control Machine
  
    def current_step
      @current_step || steps.first
    end
    
    def steps
    # %w[child mother father tutor]
      %w[child parents parents parents]
    end
    
    def next_step
      self.current_step = steps[steps.index(current_step)+1]
    end
    
    def previous_step
      self.current_step = steps[steps.index(current_step)-1]
    end
    
    def first_step?
      current_step == steps.first
    end
    
    def last_step?
      current_step == steps.last
    end
    
    def all_valid?
      steps.all? do |step|
        self.current_step = step
        valid?
      end
    end


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

