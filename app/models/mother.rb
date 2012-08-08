class Mother < Person

   before_validation :set_gender
   
   def set_gender
      self.gender = "F"
   end
   
end
