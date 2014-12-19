Spree::Taxonomy.class_eval do
  belongs_to :store
  
  
  scope :default_stores, lambda {|store| joins(:store).where("spree_stores.default = 't' or spree_stores.id = ?" ,store)}
  
  
  def default_taxonomies
    
    
    
  end
  
  
end
