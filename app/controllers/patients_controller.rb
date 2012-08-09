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
		
		session[:q_mother_search] = nil
	end
	
	def build_all   
		session_mother = session[:mother_params]
		
		@patient = Patient.new(session[:patient_params])
		@mother = (session_mother["id"].nil? )? Mother.new(session_mother) : Mother.new
		@father = Father.new(session[:father_params])
		@tutor = Tutor.new(session[:tutor_params])
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
		
		
		arr_session = {:mother => session[:mother_params], :father => session[:father_params], :tutor => session[:tutor_params]} 
		session[:current_parent_params] = arr_session[rendering_page]
			
	end


  def build_mother_search
	session[:q_mother_search] = (params[:q].nil?)? session[:q_mother_search] : params[:q]
	@search = Mother.search(session[:q_mother_search])
	@parents_search = @search.result.paginate(:page => params[:page], :per_page => 5) 
  end 
  
	def create_mother_motor
		# par défaut on reste sur la même page
		set_new_rendering_page(:mother)
		
		if params[:back_button]
			set_new_rendering_page(:child)
		elsif params[:search_parents_button]
			build_mother_search
		elsif params[:select_parent_button]
			parent_selected = params[:parent_selected]
			build_mother_search
			
			if(!parent_selected.nil?)
				mother_selected = Mother.find(parent_selected)
				if !mother_selected.nil?
					session[:mother_params] = mother_selected.attributes
					set_new_rendering_page(:father)
				end
			end
		else
			session[:mother_params] = params[:mother]
			set_new_rendering_page(:mother)
			empty_mother = Mother.new(:name=>"", :surname =>"", :cell_phone_number =>"", :email => "")
			if (@mother.attributes == empty_mother.attributes) or @mother.valid?			
				set_new_rendering_page(:father)	
			else			
				build_mother_search
			end
		end
		
		render 'new'  
	end
  
  def create
    
    if  session[:render_child]
        session[:patient_params].deep_merge!(params[:patient]) if params[:patient]
        build_all
		
		#if @patient.valid?
			set_new_rendering_page(:mother)	
			build_mother_search
		#end
		
		render 'new'
		
	elsif session[:render_mother]
		create_mother_motor
	elsif session[:render_father]
		build_all
		build_mother_search
		set_new_rendering_page(:mother)	
		render 'new'
    else
     
     
    
    build_parents(session_params["mother_attributes"].nil?, session_params["father_attributes"].nil?, session_params["tutor_attributes"].nil?)
    @patient.current_step = session[:patient_step]
    #if @patient.valid?
       if params[:back_button]
           @patient.previous_step
       elsif @patient.last_step?
           # TODO : ameliorer le reperage de cet attribut
           empty_parents_attr = {"name"=>"", "surname"=>"", "birthday(3i)"=>"", "birthday(2i)"=>"", "birthday(1i)"=>"", "cell_phone_number"=>"", "email"=>""}
           
           
           remove_mother_attr = (session_params["mother_attributes"] == empty_parents_attr)
           remove_father_attr = (session_params["father_attributes"] == empty_parents_attr)
           remove_tutor_attr = (session_params["tutor_attributes"] == empty_parents_attr)
           
           session_params.delete("mother_attributes") if remove_mother_attr
           session_params.delete("father_attributes") if remove_father_attr
           session_params.delete("tutor_attributes") if remove_tutor_attr
           
           @patient = Patient.new(session_params)
           
           if @patient.all_valid?
              @patient.save
           else
              build_parents(remove_mother_attr, remove_father_attr, remove_tutor_attr)
           end
       else
           @patient.next_step
       end
       session[:patient_step] = @patient.current_step
    #end
    
    
    if @patient.new_record?
        render "new"
    else
        session[:patient_step] = session[:patient_params] = nil
        flash[:notice] = "Patient Créé!"
        redirect_to @patient
    end
  end
  end
  
  
  def build_parents(mother,father,tutor)
        @patient.build_mother if mother
        @patient.build_father if father
        @patient.build_tutor  if tutor
  end

  def update
    @patient = Patient.find(params[:id])

    respond_to do |format|
      if @patient.update_attributes(params[:patient])
        format.html { redirect_to @patient, notice: 'Patient was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @patient = Patient.find(params[:id])
    @patient.destroy

    flash[:success] = "Patient supprime."
    redirect_to patients_path
  end
 
end
