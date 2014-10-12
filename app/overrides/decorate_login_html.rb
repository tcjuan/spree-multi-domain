Deface::Override.new(:virtual_path => "spree/shared/_login",
                      :name => "insert_store_id_hidden_tag",
                      :insert_top => "#password-credentials",
                      :text => "<%= f.field_container :store_id do %><%= f.hidden_field :store_id, :value => current_store.id %><% end %>",
                      :disabled => false)
                      
Deface::Override.new(:virtual_path => "spree/shared/_search",
                      :name => "insert_store_id_hidden_tag",
                      :insert_top => ".form",
                      :text => "<%= hidden_field_tag :store_id, current_store.id %>",
                      :disabled => false)
