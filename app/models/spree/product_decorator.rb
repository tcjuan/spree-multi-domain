Spree::Product.class_eval do
  PRODUCT_SOLR_FIELDS << :remark
  PRODUCT_SOLR_FIELDS << :permalink
  PRODUCT_SOLR_FIELDS << {:_available_on => {:as=> :available_on }}
  PRODUCT_SOLR_FIELDS << {:_available_off => {:as=> :available_off }}
#  PRODUCT_SOLR_FIELDS << {:store.id => {:as=> :store_id }}
 # PRODUCT_SOLR_FIELDS << :able_off
  #PRODUCT_SOLR_FIELDS << :available_off
  #PRODUCT_SOLR_FIELDS << :deleted_at
  # PRODUCT_SOLR_FIELDS << :store_name
  PRODUCT_SOLR_FIELDS << {:store_idds => {:as => :store, :multivalued => true}}
  acts_as_solr  :fields =>  PRODUCT_SOLR_FIELDS  , :facets => PRODUCT_SOLR_FACETS , :include => [
    {:taxons => {:as => :taxon,  :multivalued => true}} ] 
  has_and_belongs_to_many :stores, :join_table => 'spree_products_stores'
  scope :by_store, lambda {|store| joins(:stores).where("spree_products_stores.store_id = ?", store)}
  scope :by_available , where( ' ? < available_off' ,Time.now)
  
  
  def _available_on
    #"1972-05-20T17:33:18.7Z"
   self.available_on.strftime("%Y-%m-%dT%H:%M:%SZ")
  end
  
  def _available_off
    #"1972-05-20T17:33:18.7Z"
   self.available_off.strftime("%Y-%m-%dT%H:%M:%SZ")
  end
  
  def store_name
    
    self.stores.current.name
    
    
  end
  
  
  def store_idds
    
    @store_ids = []
    self.stores.each.collect do |store| @store_ids << store.id end
   
     @store_ids  
  end
  
end
