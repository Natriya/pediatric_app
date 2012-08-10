class Father < Person

   before_validation :set_gender
   
   def set_gender
      self.gender = "M"
   end
end
