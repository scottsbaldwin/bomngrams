require 'ngram_query'

class WelcomeController < ApplicationController
  def index
    @query = params[:q]
    @scores = {}
    @counts = NgramQuery.totals
    if @query
      queries = @query.split ','
      queries.each do |query|
        term = query.squish.downcase
        @scores[term] = NgramQuery.for(term).to_i
      end
    end
  end
end
