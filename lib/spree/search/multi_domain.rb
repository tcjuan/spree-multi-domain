module Spree::Search
  class MultiDomain < Spree::Core::Search::Base
    def get_base_scope(store_id)
      base_scope = @cached_product_group ? @cached_product_group.products.active.by_available : Spree::Product.active.by_available
      base_scope = base_scope.by_store(store_id) #if current_store.id
      base_scope = base_scope.in_taxon(taxon) unless taxon.blank?
      
      
      base_scope = get_products_conditions_for(base_scope, keywords) unless keywords.blank?

      base_scope = add_search_scopes(base_scope)
      base_scope
    end   
    
    def prepare(params)
      super
      @properties[:current_store_id] =  params[:current_store_id]
    end
    
    def retrieve_products(store_id=nil)
     if keywords.present?
        find_products_by_solr(keywords , store_id)
      else
        @products_scope = get_base_scope(store_id)
        @products_scope.includes([:master]).page(page).per(per_page)
      end
    end

    def products(store_id)
      if keywords.present?
        find_products_by_solr(keywords , store_id)
      else
        @products_scope = get_base_scope(store_id)
        @products_scope.includes([:master]).page(page).per(per_page)
      end
    end
  
    protected

    # NOTE: This class seems to loaded and init'd on rails startup
    # this means that any changes to the code will not take effect until the rails app is reloaded.

    def find_products_by_solr(query , store_id)
       
      # the order option does not work... it generates the solr query request correctly
      # but the returned result.records are not ordered correctly
      # search_options.merge!(:sort => (order_by_price == 'descend') ? "price desc" : "price asc")

      # TODO: find a better place to put the PRODUCT_SORT_FIELDS instead of the global constant namespace
      if not @properties[:sort].nil? and PRODUCT_SORT_FIELDS.has_key? @properties[:sort]
        sort_option = PRODUCT_SORT_FIELDS[@properties[:sort]]
      end

      # Solr query parameters: http://wiki.apache.org/solr/CommonQueryParameters
      # Adding the keyword portions sctrictly if there is a word-character match
    # filter_queries  = ["is_active:(true)"]
    filter_queries  = []
      
      if taxon 
        filter_queries << taxon.self_and_descendants.map{|t| "taxon_t:(#{t.id})"}.join(" OR ")
      end
      filter_queries << "store_t:#{store_id}" #if @properties[:current_store_id]
      filter_queries << "available_on_t:{* TO NOW}"
      filter_queries << "available_off_t:{* TO NOW}"
        
     # filter_queries << "store_t:4"

      facets = {
          :fields => PRODUCT_SOLR_FACETS,
          :browse => @properties[:facets].map{|k,v| "#{k}:#{v}"},
          :zeros => false 
      }

      # adding :scores => true here should return relevance scoring, but the underlying acts_as_solr library seems broken
      search_options = {
     #   :facets => facets,
        :limit => 25000,
     #   :lazy => true,
       :filter_queries =>filter_queries,
        :page => page, 
        :per_page => per_page
      }

      result = Spree::Product.find_by_solr(query || '', search_options)
      

   #   @count = result.total
      @count = result.docs.count
      
      Rails.logger.info "Totoal count:             #{result.count}   "
      
      @properties[:total_entries] = @count
      products = Kaminari.paginate_array(result.records, :total_count => @count).page(page).per(per_page)
      @properties[:products] = products

      @properties[:suggest] = nil
      begin
        if suggest = result.suggest
          suggest.sub!(/\sAND.*/, '')
          @properties[:suggest] = suggest if suggest != query
        end
      rescue
      end

   #   @properties[:available_facets] = parse_facets_hash(result.facets)
      Spree::Product.where("spree_products.id" => products.map(&:id))
    end

    def prepare(params)
      super
      @properties[:suggest] = nil
      @properties[:facets] = params[:facets] || {}
      @properties[:available_facets] = []
      @properties[:manage_pagination] = false
      @properties[:sort] = params[:sort] || nil
      # @properties[:order_by_price] = params[:order_by_price]
    end
    
    private
    
    def parse_facets_hash(facets_hash = {"facet_fields" => {}})
      facets = []
      facets_hash["facet_fields"].each do |name, options|
        options = Hash[*options.flatten] if options.is_a?(Array)
        next if options.size <= 1
        facet = Facet.new(name.sub('_facet', ''))
        options.each do |value, count|
          facet.options << FacetOption.new(value, count, facet.name) if value.present?
        end
        facets << facet
      end
      facets
    end
  end
  
  
  class Facet
    attr_accessor :options
    attr_accessor :name
    def initialize(name, options = [])
      self.name = name
      self.options = options
    end
  end
  
  class FacetOption
    attr_accessor :name
    attr_accessor :count
    attr_accessor :facet_name
    def initialize(name, count, facet_name)
      self.name = name
      self.count = count
      self.facet_name = facet_name
    end    
  end
    
    
  
end
