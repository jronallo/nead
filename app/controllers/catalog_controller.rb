# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController  

  include Blacklight::Catalog
  
  def show
      @response, @document = get_solr_response_for_doc_id    

      respond_to do |format|
        format.html {setup_next_and_previous_documents}

        format.xml {render :text => @document['xml_display'].first, :layout => false}

        # Add all dynamically added (such as by document extensions)
        # export formats.
        # @document.export_formats.each_key do | format_name |
        #   # It's important that the argument to send be a symbol;
        #   # if it's a string, it makes Rails unhappy for unclear reasons. 
        #   format.send(format_name.to_sym) { render :text => @document.export_as(format_name), :layout => false }
        # end
        
      end
    end

end 
