class AddStoreIdToActivators < ActiveRecord::Migration
  def self.up
   
   change_table :spree_activators do |t|
      t.string :store_id
    end
  end

  def self.down
   change_table :spree_activators do |t|
      t.remove :store_id
    end
    
  end
end
