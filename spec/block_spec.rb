# frozen_string_literal: true

require 'block'

RSpec.describe Block do
  subject do
    Block.new(index: 0, timestamp: 1_633_170_363, previous_hash: '', data: 'block')
  end

  describe 'block hash' do
    it 'computes correct block hash' do
      expect(subject.hash).to eq('f9fc45711768887d9a4716655c445654eda227b837722d3f4e3fc4dbbdd88a6f')
    end
  end
end
