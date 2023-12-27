# frozen_string_literal: true

module Ngram
  # Queries redis for ngrams
  class Query
    include Ngram::RedisConstants

    def self.for(term)
      size = term.split.length
      zscore("#{KEY_NGRAMS}:#{size}", term)
    end

    def self.totals
      counts = {}
      counts['1'] = zscore(KEY_TOTAL, 1)
      counts['2'] = zscore(KEY_TOTAL, 2)
      counts['3'] = zscore(KEY_TOTAL, 3)
      counts['4'] = zscore(KEY_TOTAL, 4)
      counts['5'] = zscore(KEY_TOTAL, 5)
      counts['6'] = zscore(KEY_TOTAL, 6)
      counts
    end

    def self.tops(num = 50)
      t = {}
      (1..6).to_a.each do |size|
        t[size.to_s] = RedisFacade.instance.redis.zrevrange("#{KEY_NGRAMS}:#{size}", 0, num, with_scores: true)
      end
      t
    end

    def self.zscore(key, num)
      RedisFacade.instance.redis.zscore(key, num)
    end
  end
end
