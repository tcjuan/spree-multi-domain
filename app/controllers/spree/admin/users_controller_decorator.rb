Spree::Admin::UsersController.class_eval do
 
   def index
    
     @users = Spree::User.where(["store_id = ?",current_store.id]).page(params[:page]).per(params[:per_page])


    
        respond_with(@collection) do |format|
          format.html
          format.json { render :json => json_data }
        end
   end
      
  private
        def user_params
          params.require(:user).permit(Spree::PermittedAttributes.user_attributes.push :spree_role_ids)
          params.require(:user).permit(Spree::PermittedAttributes.user_attributes.push :store_id)
        end
end



