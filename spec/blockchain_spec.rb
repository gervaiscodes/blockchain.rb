# frozen_string_literal: true

require 'blockchain'

RSpec.describe Blockchain do
  subject { Blockchain.new }

  describe 'blockchain initialization' do
    it 'creates genesis block' do
      expect(subject.length).to eq(1)
      expect(subject.last_block.index).to eq(0)
      expect(subject.last_block.previous_hash).to eq('')
    end
  end
end
