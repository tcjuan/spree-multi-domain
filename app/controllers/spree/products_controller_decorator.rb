Spree::ProductsController.class_eval do
  before_filter :can_show_product, :only => :show


    def index
      @searcher = build_searcher(params)
      @products = @searcher.retrieve_products(params[:store_id])
    end


  private
  def can_show_product
    @product ||= Spree::Product.find_by_permalink!(params[:id])
    if @product.stores.empty? || !@product.stores.include?(current_store)
      raise ActiveRecord::RecordNotFound
    end
  end

end
