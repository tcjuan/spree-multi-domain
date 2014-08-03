Spree::BaseHelper.module_eval do
     def meta_data_tags
       if !current_store 
            meta_data.map do |name, content|
            tag('meta', name: name, content: content)
            #tag('meta', name: current_store.name, content: content)
            end.join("\n")  
       else
          tag('meta', name: "title", content: current_store.seo_title) +
          tag('meta', name: "keywords", content: current_store.key) +
          tag('meta', name: "description", content: current_store.description)
       end 
    end
  end
 