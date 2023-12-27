# frozen_string_literal: true

# Root page controller
class WelcomeController < ApplicationController
  def index
    @query = params[:q]
    @scores = {}
    @counts = Ngram::Query.totals
    @tops = Ngram::Query.tops(50)
    return unless @query

    queries = @query.split ','
    queries.each do |query|
      term = query.squish.downcase
      @scores[term] = Ngram::Query.for(term).to_i
    end
  end
end
