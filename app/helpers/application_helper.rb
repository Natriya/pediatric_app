module ApplicationHelper

   # Retourne un titre basé sur la page.
   def titre
       base_titre = "Pediatrie"
	   if @titre.nil?
	      base_titre
	   else 
	      "#{base_titre} | #{@titre}"
	   end
   end
   
end


