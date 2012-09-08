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
		
		session[:current_parent] = ""
		
		# [New|Search|Null]
		session[:current_parent_creation_rendering] = "Null" 
		session[:mother_creation_rendering] = session[:father_creation_rendering] = session[:tutor_creation_rendering] = "Null"
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
	
	def define_parents
		session_mother = session[:mother_page_params][:mother]
		session_father = session[:father_page_params][:father]
		session_tutor = session[:tutor_page_params][:tutor]
	
		@address_mother = nil
		@address_father = nil
		@address_tutor = nil
		
		if ( session_mother.nil? or session_mother["id"].nil? )
			@mother = Mother.new(session_mother)
			@address_mother = Address.new (session[:mother_page_params][:address])
		else
			@mother = Mother.find(session_mother["id"])				
		end
		
		if ( session_father.nil? or session_father["id"].nil? )
			@father = Father.new(session_father) 
			@address_father = Address.new (session[:father_page_params][:address])
		else
			@father = Father.find(session_father["id"])	
		end
		
		if ( session_tutor.nil? or session_tutor["id"].nil? )
			@tutor = Tutor.new(session_tutor)
			@address_tutor = Address.new (session[:tutor_page_params][:address])
		else
			@tutor = Tutor.find(session_tutor["id"])
		end	
	end
	
	def save_final_patient
	
		patient_saved = false
		
		@patient = Patient.new(session[:patient_params])
		
		if @patient.valid?
			
			define_parents
			exception_raised = false
			
			ActiveRecord::Base.transaction do
				if @mother.valid?
					@address_mother.save if (!@address_mother.nil?)
					@mother.address = @address_mother
					@mother.save
					@patient.mother_id = @mother.id
				end
				
				if @father.valid?
				    @address_father.save if (!@address_father.nil?)
					@father.address = @address_father
					@father.save
					@patient.father_id = @father.id
				end
							
				if @tutor.valid?
					@address_tutor.save if (!@address_tutor.nil?)
					@tutor.address = @address_tutor
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
				flash.now[:error] = "Erreur lors de la sauvegarde du Patient\n: Patient non sauvegardé!"
			else
				flash.now[:error] = "Erreur : Patient non sauvegardé!"
			end
		else
			flash[:success] = "Nouveau patient créé avec succés"	
		end
	end
	
	def new	
	    if params[:page]
	       create
	    else
		   reset_session
		   init_params_session_for_new_patient
		   set_new_rendering_page(:mother)
		end	
	end
	
	
	def edit
		@patient = Patient.find(params[:id])
	end

	def address_parent_computed(parent)
		fill_address_parent = ( !session[:"#{parent}_page_params"].nil? and !session[:"#{parent}_page_params"][:address].nil? )
		address_parent = (fill_address_parent)? Address.new(session[:"#{parent}_page_params"][:address]) : Address.new
	end
	
	def company_parent_computed(parent)
		fill_company_parent = ( !session[:"#{parent}_page_params"].nil? and !session[:"#{parent}_page_params"][:company].nil? )
		company_parent = (fill_company_parent)? Company.find_by_id(session[:"#{parent}_page_params"][:company][:category_id]) : Company.new
	end

	def set_new_rendering_page(rendering_page)
		build_all
		
		session[:render_child] = (rendering_page == :child) 
		
		session[:render_mother] = false
		if (rendering_page == :mother) 
			session[:current_parent] = "Mère"
			session[:render_mother] = true
		end
		
		session[:render_father] = false
		if (rendering_page == :father)  
			session[:current_parent] = "Père"
			session[:render_father] = true
		end
		
		session[:render_tutor] = false
		if (rendering_page == :tutor) 
			session[:current_parent] = "Tuteur"
			session[:render_tutor] = true 
		end
		
		session[:current_parent_creation_rendering] = session[:"#{rendering_page}_creation_rendering"]
		
		
		session[:render_summary] = false
		if (rendering_page == :summary)
		    define_parents

			session[:render_summary] = true
		end
		
		session_mother = session[:mother_page_params][:mother]
		session_father = session[:father_page_params][:father]
		session_tutor = session[:tutor_page_params][:tutor]
		
		
		session_parent_param = session[:"#{rendering_page}_page_params"]
		fill_address = ( !session_parent_param.nil? and !session_parent_param[:address].nil? )
		@address = (fill_address)? Address.new(session_parent_param[:address]) : Address.new
		
		
		arr_session = {:mother => session_mother, :father => session_father, :tutor => session_tutor} 
		session[:current_parent_params] = ( arr_session[rendering_page].nil? )? {} : arr_session[rendering_page]
		@company_id_selected = (!session_parent_param.nil? and !session_parent_param[:company].nil?)? session_parent_param[:company][:company_id] : ""
		
		build_search(rendering_page)	
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
      [:mother, :father, :tutor, :child, :summary]
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
			end
		else
			build_all
		end
	end
	
	def previous_button_handler(current_step)
		set_new_rendering_page(previous_step(current_step))
	end
	
	def next_button_handler(parent)

		session[:"#{parent}_page_params"] = params
		build_all
		set_new_rendering_page(parent)
				
		parent_is_valid = false
		
		parent_is_valid = @mother.valid? if (parent == :mother) 
		parent_is_valid = @father.valid? if (parent == :father)
		parent_is_valid = @tutor.valid? if (parent == :tutor)

		if parent_is_valid
			set_new_rendering_page(next_step(parent))
		end
	end
	
	# exemple create_parent_motor(:mother)
	def create_parent_motor(parent)

		if  params[:new_parent_button]
			session[:"#{parent}_creation_rendering"] = "New"
			set_new_rendering_page(parent)
		
		elsif params[:search_parent_button]
			session[:"#{parent}_creation_rendering"] = "Search"
			set_new_rendering_page(parent)
		
		elsif params[:skip_parent_button]
			session[:"#{parent}_creation_rendering"] = "Null"
			set_new_rendering_page(next_step(parent))
		
		elsif params[:previous_button]
			previous_button_handler(parent)
		
		elsif params[:select_parent_button]
			select_parent_button_handler(parent)
		
		elsif params[:next_button]
			next_button_handler(parent)
		else
			build_all
			build_search(parent)
		end 
		
	end
  
	def create
		if  session[:render_child]
			current_step = :child
			
			if params[:previous_button]
				previous_button_handler(current_step)
			else
				session[:patient_params] = params[:patient] if params[:patient]
			    @patient = Patient.new(session[:patient_params])
				if @patient.valid?
					set_new_rendering_page(next_step(current_step))	
				end
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
