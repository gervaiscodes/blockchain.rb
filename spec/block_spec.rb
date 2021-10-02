# frozen_string_literal: true

require 'block'

RSpec.describe Block do
  subject do
    Block.new(index: 0, timestamp: 1_633_170_363, previous_hash: '', data: 'block')
  end

  describe 'block hash' do
    it 'computes correct block hash' do
      expect(subject.hash).to eq('1cde0fcd32e0da7200cc1b70aee3c5d1f116be618b9d16f92e4d6e55e6511081')
    end
  end
end
