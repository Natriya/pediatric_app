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
		session[:mother_params] ||= {}  
		session[:father_params] ||= {} 
		session[:tutor_params] ||= {}
		
		session[:current_parent_params] ||= {}
		
		session[:q_mother_search] = session[:q_father_search] = session[:q_tutor_search] = nil
	end
	
	def build_all   
		session_mother = session[:mother_params]
		session_father = session[:father_params]
		session_tutor = session[:tutor_params]
		
		@patient = Patient.new(session[:patient_params])

		@mother = (session_mother["id"].nil? )? Mother.new(session_mother) : Mother.new
		@father = (session_father["id"].nil? )? Father.new(session_father) : Father.new
		@tutor = (session_tutor["id"].nil? )? Tutor.new(session_tutor) : Tutor.new
	end
	
	def save_final_patient
	
		
		patient_saved = false
		
		session_mother = session[:mother_params]
		session_father = session[:father_params]
		session_tutor = session[:tutor_params]
		
		@patient = Patient.new(session[:patient_params])
		
		if @patient.valid?
			@mother = (session_mother["id"].nil? )? Mother.new(session_mother) : Mother.find(session_mother["id"])
			@father = (session_father["id"].nil? )? Father.new(session_father) : Father.find(session_father["id"])
			@tutor = (session_tutor["id"].nil? )? Tutor.new(session_tutor) : Tutor.find(session_tutor["id"])
			
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
		
		if patient_saved
			redirect_to @patient
		else
			render 'new'
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
		session[:render_summary] = (rendering_page == :summary)
		
		
		arr_session = {:mother => session[:mother_params], :father => session[:father_params], :tutor => session[:tutor_params]} 
		session[:current_parent_params] = arr_session[rendering_page]
			
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
  
    build_mother_search if(parent == :mother)
    build_father_search if(parent == :father)
    build_tutor_search if(parent == :tutor)
    
	@parents_search = @search.result.paginate(:page => params[:page], :per_page => 5)  if (parent != :summary and parent != :child) 
  end 
  
	def steps
      [:child, :mother, :father, :tutor, :summary]
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
				session[:"#{parent}_params"] = specific_parent_selected.attributes
				set_new_rendering_page(next_step(parent))
				build_search(next_step(parent))		
			end
		end
	end
	
	def next_button_handler(parent)

		session[:"#{parent}_params"] = params[parent]
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
		
		go_next_page = (go_next_page or parent_is_valid)  
		
		go_next_page = (go_next_page and ((current_attr == empty_parent_attr) or parent_is_valid))
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
		
		if params[:back_button]
			set_new_rendering_page(previous_step(parent))
			build_search(previous_step(parent))
		elsif params[:search_parents_button]
			build_search(parent)
		elsif params[:select_parent_button]
			select_parent_button_handler(parent)
		else
			next_button_handler(parent)
		end
		
		render 'new'  
	end
	
	def uniform_attr(attr)
		attr.delete("gender")
		attr.delete("type")
	end
  
	def create
		if  session[:render_child]
			session[:patient_params].deep_merge!(params[:patient]) if params[:patient]
			build_all
			
			if @patient.valid?
				set_new_rendering_page(:mother)	
				build_search(:mother)
			end
			
			render 'new'
			
		elsif session[:render_mother]
			create_parent_motor(:mother)
		elsif session[:render_father]
			create_parent_motor(:father)
		elsif session[:render_tutor]
			create_parent_motor(:tutor)
		else
			if params[:back_button]
				set_new_rendering_page(:tutor)
				build_search(:tutor)
				render 'new'
			else
				save_final_patient
			end
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
