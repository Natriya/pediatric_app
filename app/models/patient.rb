# encoding: utf-8

class Patient < ActiveRecord::Base
  attr_accessible :birthday, :father_id, :mother_id, :name, :next_appointment_date, 
                  :gender, :surname, :tutor_id, :company_patient_identification,
                  :mother_attributes, :father_attributes, :tutor_attributes
  
  attr_writer :current_step
  

  belongs_to :father, :inverse_of => :patients
  belongs_to :mother, :inverse_of => :patients
  belongs_to :tutor, :inverse_of => :patients
  
  validates :name, :surname, :presence => true
  validates :gender, :inclusion => { :in => %w(M F) }
  
  accepts_nested_attributes_for :father, :mother, :tutor
  
  # validate :patient_has_parents?
  
  def patient_has_parents?
     value = ((!father.nil? and father.valid?) or (!mother.nil? and mother.valid?) or (!tutor.nil? and tutor.valid?))
     errors.add(:base, "Patient must have Parents") unless value
     value
  end
  
  
  def full_name
    "#{surname} #{name}" 
  end
  
  def mother_fullname
    "#{mother.surname} #{mother.name}" unless mother.nil?
  end
  
  def father_fullname
    "#{father.surname} #{father.name}" unless father.nil?
  end
  
  def tutor_fullname
    "#{tutor.surname} #{tutor.name}" unless tutor.nil?
  end
  
  #############################################
  #### Steps Wizard Control Machine
  #############################################
  
    
    def current_step
      @current_step || steps.first
    end
    
    def form_to_render
        if first_step?
            "form_child"
        else
            "form_parents"
        end
    end
    
    def current_parent
        arr = { "mother" => "Mère", "father" => "Père", "tutor" => "Tuteur" }
        arr[current_step]
    end
    
    def steps
      %w[child mother father tutor]
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
