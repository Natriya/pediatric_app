class SessionsController < ApplicationController

  def new
    @titre = "S'identifier"
  end

  def create
    user = User.authenticate(params[:session][:username],
                             params[:session][:password])
    if user.nil?
        # Crée un message d'erreur et rend le formulaire
        flash.now[:error] = "Combinaison Pseudonyme/Mot de passe invalide."
        @titre = "S'identifier"
        render 'new'
    else
        # Authentifie l'utilisateur et redirige vers la page d'affichage.
        sign_in user
        redirect_back_or root_path
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
