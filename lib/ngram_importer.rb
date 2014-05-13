require 'nokogiri'
require 'redis'
require 'ngram_redis_constants'

class NgramImporter
  include NgramRedisContants

  def initialize(file = File.expand_path("bom.xml", Rails.root))
    @file = file
    puts $redis.keys
  end

  def run(values_of_n = (3..5).to_a)
    keys = values_of_n.map { |v| set_key(v) }
    $redis.del(*keys)
    keys.each { |k| $redis.zrem(KEY_TOTAL, k) }

    doc = Nokogiri::XML(File.open(@file))
    books = doc.xpath("//book")
    books.each do |book|
      verses = book.xpath('./chapter/verse')
      puts "Storing ngrams for #{book['name']} (#{verses.length} verses)..."
      verses.each do |verse|
        words = cleanup(verse.content).downcase.split
        values_of_n.each do |n|
          ngram words, n
        end
      end
    end
  end

  private

  def set_key(num)
    "#{KEY_NGRAMS}:#{num}"
  end

  def cleanup(text)
    # squish equivalent
    text.gsub!(/\A[[:space:]]+/, '')
    text.gsub!(/[[:space:]]+\z/, '')
    text.gsub!(/[[:space:]]+/, ' ')
    # remove punctuation
    text.gsub!(/[^[[:word:]]\s]/, '')
    text
  end

  def ngram(words, size)
    words.each_cons(size) do |gram|
      $redis.zincrby(set_key(size), 1, gram.join(' '))
      $redis.zincrby(KEY_TOTAL, 1, size)
    end
  end

end
