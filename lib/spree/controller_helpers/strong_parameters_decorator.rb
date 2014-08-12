Spree::Core::ControllerHelpers::StrongParameters.module_eval do
  def permitted_user_attributes
          permitted_attributes.user_attributes + [
           :store_id_attributes => permitted_store_id_attributes
          ]
  end
end
