class Father < Person

   before_validation :set_gender
   
   def set_gender
      puts "titi"
      self.gender = "M"
   end
end
