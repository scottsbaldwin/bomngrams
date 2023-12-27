# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ngram::Importer do
  subject { Ngram::Importer.new }
  let(:redis_instance) { instance_double('Redis') }
  let(:values_of_n) { (3..5).to_a }

  # before do
  #   allow(RedisClient).to receive(:instance).and_return(redis_instance)
  # end

  # describe '#run' do
  #   let(:result) { subject.run(values_of_n) }
  #   it 'processes all books and stores ngrams in Redis' do
  #     values_of_n.each do |n|
  #       # expect(ngram_importer.redis_key_exists?("ngram:#{n}")).to be_truthy
  #       expect(redis_instance).to receive(:del).with("ngram:#{n}")
  #       # expect(redis_instance).to receive(:zrem).with(NgramImporter::KEY_TOTAL, "ngram:#{n}")
  #     end
  #   end
  # end
end
