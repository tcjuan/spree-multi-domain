class AddStoreIdToUsers < ActiveRecord::Migration
  def self.up
   
   change_table :spree_users do |t|
      t.integer :store_id
    end
  end

  def self.down
   change_table :spree_users do |t|
      t.remove :store_id
    end
    
  end
end
