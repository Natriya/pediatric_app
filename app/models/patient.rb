# encoding: utf-8

class Patient < ActiveRecord::Base
  attr_accessible :birthday, :father_id, :mother_id, :name, :next_appointment_date, 
                  :gender, :surname, :tutor_id, 
                  :mother_attributes, :father_attributes, :tutor_attributes
  
  

  belongs_to :father, :inverse_of => :patients
  belongs_to :mother, :inverse_of => :patients
  belongs_to :tutor, :inverse_of => :patients
  
  validates :name, :surname, :presence => true
  validates :gender, :inclusion => { :in => %w(M F) }
  
  accepts_nested_attributes_for :father, :mother, :tutor
  
  validate :patient_has_parents?
  
  def patient_has_parents?
     value = ((!father.nil? and father.valid?) or (!mother.nil? and mother.valid?) or (!tutor.nil? and tutor.valid?))
     errors.add(:base, "Patient must have Parents") unless value
  end
  



end
