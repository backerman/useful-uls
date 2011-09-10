require 'riddle'
require 'riddle/2.0.1'
require 'yajl'

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
   42 
  end


end
