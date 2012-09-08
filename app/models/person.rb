class Person < ActiveRecord::Base
  attr_accessible :address_id, :birthday, :cell_phone_number, :email, 
				  :name, :gender, :surname, 
				  :company_person_identification, :occupation, :address
                  
  attr_writer :current_step

  belongs_to :address
  
  has_many :patients
  
  # parameters if person belongs to a company
  belongs_to :company
  
  #validates_associated :patients

  validates :name, :surname, :presence => true
  validates :gender, :inclusion => { :in => %w(M F) }
  #validates :company_person_identification, :numericality => {:only_integer => true, :greater_than => 0 } , 
  #                                          :allow_nil => true
   
  
   
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

