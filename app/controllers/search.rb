UsefulUls.class_eval do
  # Add constants
  ENTITY_DISPLAY_COLS =
    [ :unique_system_identifier,
      :callsign,
      :licensee_id,
      :entity_name,
      :phone,
      :fax,
      :email ]
end

UsefulUls.controllers :search do
  # get :index, :map => "/foo/bar" do
  #   session[:foo] = "bar"
  #   render 'index'
  # end

  # get :sample, :map => "/sample/url", :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  get :index do
    render 'search/index'
  end

  get :autocomplete, :provides => [:json] do
    @results = sphinx_search params[:term], 10,
      :sort_by => "@weight DESC, licensee_name ASC, licensee_attn ASC"
    render 'search/autocomplete'
  end

  get :systems do
    # Use Sphinx to retrieve ULS IDs, then query database to get system
    # information.
    fts_results = sphinx_search(params[:term], 100)
    docs = fts_results[:matches].map {|m| m[:doc]}
    @results = System.filter(:unique_system_identifier => docs)
    # @columns = ENTITY_DISPLAY_COLS
    @columns = @results.columns
    render 'search/systems'
  end


end
