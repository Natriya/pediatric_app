# encoding: utf-8


class PatientsController < ApplicationController

	def index
		@search = Patient.search(params[:q])
		@patients = @search.result.paginate(:page => params[:page], :per_page => 5)  
	end
	
	def show
		@patient = Patient.find(params[:id])
	end
	
	
	def init_params_session_for_new_patient
		session[:patient_params] ||= {} 
		session[:mother_page_params] ||= {}  
		session[:father_page_params] ||= {} 
		session[:tutor_page_params] ||= {}
		
		session[:current_parent_params] ||= {}
		
		session[:q_mother_search] = session[:q_father_search] = session[:q_tutor_search] = nil
	end
	
	def build_all   
		session_mother = session[:mother_page_params][:mother]
		session_father = session[:father_page_params][:father]
		session_tutor = session[:tutor_page_params][:tutor]
		
		@patient = Patient.new(session[:patient_params])

		@mother = (session_mother.nil? or session_mother["id"].nil? )? Mother.new(session_mother) : Mother.new
		@father = (session_father.nil? or session_father["id"].nil? )? Father.new(session_father) : Father.new
		@tutor = (session_tutor.nil? or session_tutor["id"].nil? )? Tutor.new(session_tutor) : Tutor.new
	end
	
	def save_final_patient
	
		patient_saved = false
		
		session_mother = session[:mother_page_params][:mother]
		session_father = session[:father_page_params][:father]
		session_tutor = session[:tutor_page_params][:tutor]
		
		@patient = Patient.new(session[:patient_params])
		
		if @patient.valid?
			@mother = ( session_mother.nil? or session_mother["id"].nil? )? Mother.new(session_mother) : Mother.find(session_mother["id"])
			@father = ( session_father.nil? or session_father["id"].nil? )? Father.new(session_father) : Father.find(session_father["id"])
			@tutor = ( session_tutor.nil? or session_tutor["id"].nil? )? Tutor.new(session_tutor) : Tutor.find(session_tutor["id"])
			
			exception_raised = false
			
			ActiveRecord::Base.transaction do
				if @mother.valid?
					@mother.save
					@patient.mother_id = @mother.id
				end
				
				if @father.valid?
					@father.save
					@patient.father_id = @father.id
				end
							
				if @tutor.valid?
					@tutor.save
					@patient.tutor_id = @tutor.id
				end			
	
				if @patient.valid? and @patient.patient_has_parents?
					@patient.save
					patient_saved = true
				end
			end
		end


		if @patient.new_record?     
			if patient_saved
				flash[:error] = "Erreur lors de la sauvegarde du Patient\n: Patient non sauvegardé!"
			else
				flash[:error] = "Erreur : Patient non sauvegardé!"
			end
		else
			flash[:success] = "Nouveau patient créé avec succés"	
		end
	end
	
	def new	
		reset_session
		init_params_session_for_new_patient
		set_new_rendering_page(:child)		
	end
	
	
	def edit
		@patient = Patient.find(params[:id])
	end


	def set_new_rendering_page(rendering_page)
		build_all
		
		session[:render_child] = (rendering_page == :child) 
		session[:render_mother] = (rendering_page == :mother)  
		session[:render_father] = (rendering_page == :father)  
		session[:render_tutor] = (rendering_page == :tutor)
		session[:render_addresses]  = (rendering_page == :addresses)
		session[:render_summary] = (rendering_page == :summary)
		
		
		session_mother = session[:mother_page_params][:mother]
		session_father = session[:father_page_params][:father]
		session_tutor = session[:tutor_page_params][:tutor]
		
		
		session_parent_param = session[:"#{rendering_page}_page_params"]
		fill_address = ( !session_parent_param.nil? and !session_parent_param[:address].nil? )
		@address = (fill_address)? Address.new(session_parent_param[:address]) : Address.new
		
		
		arr_session = {:mother => session_mother, :father => session_father, :tutor => session_tutor} 
		session[:current_parent_params] = ( arr_session[rendering_page].nil? )? {} : arr_session[rendering_page]
			
	end


  def build_mother_search
	session[:q_mother_search] = (params[:q].nil?)? session[:q_mother_search] : params[:q]
	@search = Mother.search(session[:q_mother_search])
  end 
  
  def build_father_search
	session[:q_father_search] = (params[:q].nil?)? session[:q_father_search] : params[:q]
	@search = Father.search(session[:q_father_search])
  end
  
  def build_tutor_search
	session[:q_tutor_search] = (params[:q].nil?)? session[:q_tutor_search] : params[:q]
	@search = Tutor.search(session[:q_tutor_search])
  end
  
  
  
  def build_search(parent)
	if ( (parent == :mother) or (parent == :father) or (parent == :tutor) ) 
	    build_mother_search if(parent == :mother)
	    build_father_search if(parent == :father)
	    build_tutor_search if(parent == :tutor)
	    
		@parents_search = @search.result.paginate(:page => params[:page], :per_page => 5) 
	end 
  end 
  
	def steps
      [:child, :mother, :father, :tutor, :summary]
      #[:child, :mother, :father, :tutor, :addresses, :summary]
    end
	
	def next_step(current_step)
      steps[steps.index(current_step)+1]
    end
    
    def previous_step(current_step)
      steps[steps.index(current_step)-1]
    end
	
	def select_parent_button_handler(parent)
		parent_selected = params[:parent_selected]
		build_search(parent)
		
		if(!parent_selected.nil?)
			
			specific_parent_selected = Mother.find(parent_selected) if (parent == :mother)
			specific_parent_selected = Father.find(parent_selected) if (parent == :father)
			specific_parent_selected = Tutor.find(parent_selected) if (parent == :tutor)
			
			if !specific_parent_selected.nil?
				session[:"#{parent}_page_params"][parent] = specific_parent_selected.attributes
				set_new_rendering_page(next_step(parent))
				build_search(next_step(parent))		
			end
		end
	end
	
	def previous_button_handler(current_step)
		set_new_rendering_page(previous_step(current_step))
		build_search(previous_step(current_step))	
	end
	
	def next_button_handler(parent)

		session[:"#{parent}_page_params"] = params
		set_new_rendering_page(parent)
		
		empty_parent = Person.new(:name=>"", :surname =>"", :cell_phone_number =>"", :email => "")
		empty_parent_attr = empty_parent.attributes
		uniform_attr(empty_parent_attr)
		
		mother_attr = @mother.attributes
		father_attr = @father.attributes
		tutor_attr = @tutor.attributes
		
		go_next_page = tutor_attr["gender"].blank?
		
		uniform_attr(mother_attr)
		uniform_attr(father_attr)
		uniform_attr(tutor_attr)
		
		parent_is_valid = false
		
		if (parent == :mother) 
			current_attr = mother_attr
			parent_is_valid = @mother.valid?
		elsif (parent == :father)
			current_attr = father_attr
			parent_is_valid = @father.valid?
		elsif (parent == :tutor)
			current_attr = tutor_attr
			parent_is_valid = @tutor.valid?
		end
		
		blank_address = {"address"=>"", "phone_number"=>""}
		
		go_next_page = (go_next_page or parent_is_valid)
		all_attr_empty =  ( (current_attr == empty_parent_attr) and (params[:address] == blank_address) )
		
		go_next_page = (go_next_page and ( all_attr_empty or parent_is_valid))
		
		#debugger
		if go_next_page
			set_new_rendering_page(next_step(parent))
			build_search(next_step(parent))
		else
			build_search(parent)
		end
	end
	
	# exemple create_parent_motor(:mother)
	def create_parent_motor(parent)
		# par défaut on reste sur la même page
		set_new_rendering_page(parent)
		
		if params[:previous_button]
			previous_button_handler(parent)
		elsif params[:search_parents_button]
			build_search(parent)
		elsif params[:select_parent_button]
			select_parent_button_handler(parent)
		else
			next_button_handler(parent)
		end 
	end
	
	def uniform_attr(attr)
		attr.delete("gender")
		attr.delete("type")
	end
  
	def create
		if  session[:render_child]
			session[:patient_params] = params[:patient] if params[:patient]
			build_all
			
			if @patient.valid?
				set_new_rendering_page(:mother)	
				build_search(:mother)
			end
			
		elsif session[:render_mother]
			create_parent_motor(:mother)
		elsif session[:render_father]
			create_parent_motor(:father)
		elsif session[:render_tutor]
			create_parent_motor(:tutor)
		else # render summary
			if params[:previous_button]
				previous_button_handler(steps.last)
			else
				save_final_patient
			end
		end
		
		if @patient.new_record?
			render 'new'
		else
			redirect_to @patient
		end
	end
 

  def update
    @patient = Patient.find(params[:id])
  end

  def destroy
    @patient = Patient.find(params[:id])
    @patient.destroy

    flash[:success] = "Patient supprime."
    redirect_to patients_path
  end
 
end
