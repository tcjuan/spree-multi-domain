Spree::Product.class_eval do
  PRODUCT_SOLR_FIELDS << :remark
  PRODUCT_SOLR_FIELDS << :permalink
 # PRODUCT_SOLR_FIELDS << :store_name
  #PRODUCT_SOLR_FIELDS << {:store_name => {:type => :integer ,:as =>:supplier_id}}
  acts_as_solr  :fields =>  PRODUCT_SOLR_FIELDS  , :facets => PRODUCT_SOLR_FACETS , :include => [
    {:taxons => {:as => :taxon,  :multivalued => true}} ,
    {:stores => {:as => :store,  :multivalued => true}}
    ]
  has_and_belongs_to_many :stores, :join_table => 'spree_products_stores'
  scope :by_store, lambda {|store| joins(:stores).where("spree_products_stores.store_id = ?", store)}
  
  
  def store_name
    
    self.stores.current.name
    
    
  end
  
end
