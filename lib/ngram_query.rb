require 'ngram_redis_constants'

class NgramQuery
  include NgramRedisContants

  def self.for(term)
    size = term.split.length
    $redis.zscore("#{KEY_NGRAMS}:#{size}", term)
  end
end
