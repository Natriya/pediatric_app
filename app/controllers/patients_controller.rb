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
		
		set_new_rendering_page(:child)
		
		init_params_session_for_new_patient
		build_all
	end
	
	
	def edit
		@patient = Patient.find(params[:id])
	end


	def set_new_rendering_page(rendering_page)
		session[:render_child] = (rendering_page == :child) 
		session[:render_mother] = (rendering_page == :mother)  
		session[:render_father] = (rendering_page == :father)  
		session[:render_tutor] = (rendering_page == :tutor)  
	end


  def build_mother_search
	@search = Mother.search(params[:q])
	@parents_search = @search.result.paginate(:page => params[:page], :per_page => 5) 
  end 
  
  def create
     #debugger
    
    if  session[:render_child]
        session[:patient_params].deep_merge!(params[:patient]) if params[:patient]
        build_all
		
		#if @patient.valid?
			set_new_rendering_page(:mother)	
			build_mother_search
		#end
		
		render 'new'
		
	elsif session[:render_mother]
	
		session_mother = session[:mother_params]
		params_mother = params[:mother]
		if (!session_mother["id"].nil? and params_mother)
			session_mother.deep_merge!(params_mother) 
		end
		build_all
		
		if params[:back_button]
			set_new_rendering_page(:child)
		elsif params[:search_parents_button]
			build_mother_search
		elsif params[:select_parent_button]
			build_mother_search
			mother_selected = Mother.find(params[:parent_selected])
			session[:mother_params] = mother_selected.attributes
			set_new_rendering_page(:father)
		else
			empty_mother = Mother.new(:name=>"", :surname =>"", :cell_phone_number =>"", :email => "")
			if (@mother.attributes == empty_mother.attributes) or @mother.valid?
				build_all
				set_new_rendering_page(:father)	
			else
				build_mother_search
			end
		end
		render 'new'
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

  # PUT /patients/1
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

  # DELETE /patients/1
  def destroy
    @patient = Patient.find(params[:id])
    @patient.destroy

    flash[:success] = "Patient supprime."
    redirect_to patients_path
  end
  
  
  
  def parent_button_handler
    parent_metaname = params[:parents_button].split().second
    if parent_metaname == parents_metanames.first
        session[:mother_button] = (session[:mother_button] == states_add_rm_mother.first)? states_add_rm_mother.second : states_add_rm_mother.first
        session[:mother_render] = !session[:mother_render]
        @patient.build_mother if session[:mother_render]
    elsif parent_metaname == parents_metanames.second
        session[:father_button] = (session[:father_button] == states_add_rm_father.first)? states_add_rm_father.second : states_add_rm_father.first
        session[:father_render] = !session[:father_render]
        @patient.build_father if session[:father_render]
    elsif parent_metaname == parents_metanames.third
        session[:tutor_button] = (session[:tutor_button] == states_add_rm_tutor.first)? states_add_rm_tutor.second : states_add_rm_tutor.first
        session[:tutor_render] = !session[:tutor_render]
        @patient.build_tutor if session[:tutor_render]
    end
  end
 
end
