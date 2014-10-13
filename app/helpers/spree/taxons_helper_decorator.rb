module Spree
    TaxonsHelper.class_eval do   
      def taxon_preview(taxon, max=4)
      products = taxon.active_products.by_store(current_store.id).limit(max).uniq
      if (products.size < max)
        products_arel = Spree::Product.arel_table
        taxon.descendants.each do |taxon|
          to_get = max - products.length
          products += taxon.active_products.by_store(current_store.id).where(products_arel[:id].not_in(products.map(&:id))).limit(to_get).uniq
          break if products.size >= max
        end
      end
      products
    end     
    end
end

