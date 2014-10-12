Spree::TaxonsController.class_eval do
 # before_filter :can_show_product, :only => :show
    rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    helper 'spree/products'

    respond_to :html

    def show
      @taxon = Spree::Taxon.find_by_permalink!(params[:id])
      return unless @taxon

      @searcher = build_searcher(params.merge(:taxon => @taxon.id))
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
