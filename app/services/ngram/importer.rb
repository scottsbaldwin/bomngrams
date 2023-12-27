# frozen_string_literal: true

require 'nokogiri'
require 'redis'

module Ngram
  # Imports ngrams into Redis
  class Importer
    include Ngram::RedisConstants

    def initialize(file = File.expand_path('bom.xml', Rails.root))
      @file = file
    end

    def run(values_of_n = (3..5).to_a)
      clear_redis_keys(values_of_n)

      books.each do |book|
        verses = verses_in_book(book)
        puts "Storing ngrams for #{book['name']} (#{verses.length} verses)..."
        process_verses(verses, values_of_n)
      end
    end

    private

    def books
      doc = Nokogiri::XML(File.open(@file))
      @books = doc.xpath('//book')
    end

    def verses_in_book(book)
      book.xpath('./chapter/verse')
    end

    def process_verses(verses, values_of_n)
      verses.each_with_index do |verse, index|
        puts "Calculating ngrams for verse #{index + 1} of #{verses.length}"
        words = cleanup(verse.content)
        values_of_n.each do |n|
          ngram words, n
        end
      end
    end

    def clear_redis_keys(values_of_n)
      keys = values_of_n.map { |v| key_name(v) }
      RedisFacade.instance.redis.del(*keys)
      keys.each { |k| RedisFacade.instance.redis.zrem(KEY_TOTAL, k) }
    end

    def cleanup(text)
      # squish equivalent
      text.gsub!(/\A[[:space:]]+/, '')
      text.gsub!(/[[:space:]]+\z/, '')
      text.gsub!(/[[:space:]]+/, ' ')
      # remove punctuation
      text.gsub!(/[^[[:word:]]\s]/, '')
      text.downcase.split
    end

    def key_name(num)
      "#{KEY_NGRAMS}:#{num}"
    end

    def ngram(words, size)
      words.each_cons(size) do |gram|
        RedisFacade.instance.redis.zincrby(key_name(size), 1, gram.join(' '))
        RedisFacade.instance.redis.zincrby(KEY_TOTAL, 1, size)
      end
    end
  end
end
