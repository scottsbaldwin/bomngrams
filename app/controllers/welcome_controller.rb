require 'ngram_query'

class WelcomeController < ApplicationController
  def index
    @query = params[:q]
    @scores = {}
    if @query
      queries = @query.split ','
      queries.each do |query|
        term = query.squish
        @scores[term] = NgramQuery.for(term).to_i
      end
    end
  end
end
