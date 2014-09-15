Spree::UserRegistrationsController.class_eval do
 

  def new
    super
    @user = resource
  end

  # POST /resource/sign_up
  def create
    
    @user = build_resource(spree_user_params)
    if @user.save!
      set_flash_message(:notice, :signed_up)
      sign_in(:spree_user, @user)
      session[:spree_user_signup] = true
      associate_user
      respond_with resource, location: after_sign_up_path_for(resource)
    else
      clean_up_passwords(resource)
      render :new
    end
  end
      
  private
  
  
    def spree_user_params
      params.require(:spree_user).permit(Spree::PermittedAttributes.user_attributes)
      params.require(:spree_user).permit(Spree::PermittedAttributes.user_attributes.push :store_id)
    end
    
    
 
end



