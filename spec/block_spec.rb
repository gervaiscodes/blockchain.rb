# frozen_string_literal: true

require 'block'

RSpec.describe Block do
  let(:block) do
    Block.new(0, 1_633_170_363, 1, '', 'block')
  end

  describe 'block hash' do
    it 'computes correct block hash' do
      expect(block.hash).to eq('4bb3e3221ebbcae41501796460764329bb02f2a2ae26871ed4fa1a43bd341a7d')
    end
  end
end
