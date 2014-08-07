class AddKeysAndDescriptionsToStore < ActiveRecord::Migration
 def self.up
   
   change_table :spree_stores do |t|
      t.string :seo_title
      t.string :key
      t.string :description
      
    end
     
  
  end

  def self.down
   
   change_table :spree_stores do |t|
      t.remove :seo_title
      t.remove :key
      t.remove :description
    end
    
  end
end
