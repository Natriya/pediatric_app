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

   def parent_birthday(builder, var)
      builder.date_select var, :order => [:day, :month, :year], :start_year => Date.today.years_ago(100).year, :end_year => Date.today.years_ago(10).year, :use_month_numbers => true, :include_blank => true
   end
   
   def child_birthday(builder, var)
      builder.date_select var, :order => [:day, :month, :year], :start_year => Date.today.years_ago(21).year, :end_year => Date.today.year, :use_month_numbers => true, :include_blank => true
   end
   
   def custrom_date_helper(builder, var)
      builder.date_select var, :order => [:day, :month, :year], :start_year => Date.today.years_ago(2).year, :end_year => Date.today.years_since(5).year, :use_month_numbers => true, :include_blank => true   
   end
end


