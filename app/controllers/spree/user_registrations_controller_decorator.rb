Spree::UserRegistrationsController.class_eval do
 
  
      
  private
  
  
    def spree_user_params
      params.require(:spree_user).permit(Spree::PermittedAttributes.user_attributes)
      params.require(:spree_user).permit(Spree::PermittedAttributes.user_attributes.push :store_id)
    end
    
       
end



