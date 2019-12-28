require 'ngram_redis_constants'

class NgramQuery
  include NgramRedisContants

  def self.for(term)
    size = term.split.length
    $redis.zscore("#{KEY_NGRAMS}:#{size}", term)
  end

  def self.totals
    counts = {}
    counts["3"] = $redis.zscore(KEY_TOTAL, 3)
    counts["4"] = $redis.zscore(KEY_TOTAL, 4)
    counts["5"] = $redis.zscore(KEY_TOTAL, 5)
    counts
  end
end
