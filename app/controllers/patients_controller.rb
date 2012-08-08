# encoding: utf-8


class PatientsController < ApplicationController
  # GET /patients
  def index
    @patients = Patient.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @patients }
    end
  end

  # GET /patients/1
  def show
    @patient = Patient.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @patient }
    end
  end

  # GET /patients/new
  def new
    @patient = Patient.new
    
    session[:mother_button] = states_add_rm_mother.first
    session[:father_button] = states_add_rm_father.first
    session[:tutor_button] = states_add_rm_tutor.first
    
    session[:mother_render] = session[:father_render] = session[:tutor_render] = false
  end
  

  def parents_metanames
      %w[ Mère Père Tuteur ]
  end
  
  def states_add_rm(parent_metaname)
    [ "Ajouter #{parent_metaname}" , "Supprimer #{parent_metaname}" ]
  end 
  
  
  def states_add_rm_mother
     states_add_rm(parents_metanames.first) 
  end
  
  def states_add_rm_father
     states_add_rm(parents_metanames.second)
  end
  
  def states_add_rm_tutor
     states_add_rm(parents_metanames.third)
  end
 


  # GET /patients/1/edit
  def edit
    @patient = Patient.find(params[:id])
  end

  # POST /patients
  # POST /patients.json
  def create
    @patient = Patient.new(params[:patient])
    
    if params[:commit] != "Créer"
    
        parent_metaname = params[:commit].split().second
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
        
        render 'new'
        
    else
        @patient = Patient.new(params[:patient])    
        
        
        if @patient.save
            flash[:success] = "Patient créé avec succés"     
            redirect_to patients_path
        else
            render 'new'
        end
    end
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
 
end
