Deface::Override.new(
  :virtual_path => "spree/admin/products/_form",
  :name => "multi_domain_admin_products_edit_taxon",
  :replace => "[data-hook='admin_product_taxons']",
  :partial => "spree/admin/products/edit_taxon",
  :disabled => false)
