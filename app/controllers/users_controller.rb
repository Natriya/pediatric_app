class UsersController < ApplicationController


  include UsersHelper
  
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :admin_create_user, :only => [:new]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:index, :destroy]


  def new
    @user = User.new
    @titre = "Inscription"
  end

  def index
    @titre = "Tous les utilisateurs"
    @users = User.paginate(:page => params[:page])
  end

  def create
    if params[:bascule]
        user = User.find_by_id(params[:bascule][:b_user_id])
        user.toggle!(:admin)
        flash[:success] = "Utilisateur #{user.username} bascule avec succes!"

        redirect_to users_path
    else  
        @user= User.new(params[:user])
        users_exist_before_save = users_exist?
        if !users_exist_before_save
             @user.toggle(:admin)
        end
        if @user.save
            if !users_exist_before_save
               sign_in @user
               flash[:success] = "Bienvenue dans l'Application Pediatrie!"
               redirect_to root_path
            else
                flash[:success] = "Nouvel Utilisateur cree avec succes!"
                redirect_to users_path
             end
        else
            @titre = "Inscription"
            render 'new'
        end
     end
  end

  def edit
    @titre = "Edition profil"
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profil actualise"
      redirect_to root_path
    else
      @titre = "Edition profil"
      render 'edit'
    end
  end

  def destroy
    user_to_destroy = User.find(params[:id])
    if current_user?(user_to_destroy)
       flash[:error] = "Echec : Vous ne pouvez pas vous supprimer vous meme"
       redirect_to users_path
    else
       user_to_destroy.destroy
       flash[:success] = "Utilistaeur supprime."
       redirect_to users_path
    end
  end
  
  def toggle_admin
  end
  
  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless (!current_user.nil? and current_user.admin?)
    end
    
    def admin_create_user
      if users_exist?
         admin_user
      end
    end
  
  
end
