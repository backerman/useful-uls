# Helper methods defined here can be accessed in any controller or view in the application

require 'riddle'
require 'riddle/2.0.1'

UsefulUls.helpers do
  def sphinx_search(term, row_limit=100, options={})
    @sphinx ||= Riddle::Client.new 'sphinx.facefault.org', 9312
    @sphinx.limit = row_limit
    @sphinx.sort_by =
      if options[:sort_by]
        options[:sort_by]
      else
        ''
      end
    @sphinx.query(term)
  end
end
