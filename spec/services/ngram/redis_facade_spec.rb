# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ngram::RedisFacade do
  subject { Ngram::RedisFacade.instance }
  let(:redis_instance) { instance_double('Redis') }

  describe '#initialize' do
    it 'creates a new Redis instance' do
      expect(subject.client).to be_instance_of(Redis)
    end

    context 'when REDIS_URL is not set' do
      before do
        ENV.delete('REDIS_URL')
      end

      it 'creates a Redis instance with the default host and port' do
        expect(subject.client.connection[:host]).to eq('localhost')
        expect(subject.client.connection[:port]).to eq(6379)
      end
    end
  end
end
