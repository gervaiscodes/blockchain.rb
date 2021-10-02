# frozen_string_literal: true

require 'blockchain'

RSpec.describe Blockchain do
  let(:blockchain) { Blockchain.new }

  describe 'blockchain initialization' do
    it 'creates genesis block' do
      expect(blockchain.length).to eq(1)
      expect(blockchain.last_block.index).to eq(0)
      expect(blockchain.last_block.previous_hash).to eq('')
    end
  end

  describe 'blockchain validation' do
    context 'valid blockchain' do
      before do
        blockchain.append(
          Block.new(
            index: 1,
            timestamp: 1_633_173_441,
            previous_hash: '075c27741a3506846368fa6e5b3477f85b31ceee71a5716e2f12b40fa21d23aa',
            data: 'Second block'
          )
        )
        blockchain.append(
          Block.new(
            index: 2,
            timestamp: 1_633_173_565,
            previous_hash: '5b781b11ade2d9f65010e18aaf809d67a37757af5173aa6f8385de19cb5d71e6',
            data: 'Third block'
          )
        )
      end

      it 'validates blockchain' do
        expect(blockchain.valid?).to be true
      end
    end

    context 'invalid blockchain (wrong hashes)' do
      before do
        blockchain.append(
          Block.new(
            index: 1,
            timestamp: 1_633_173_441,
            previous_hash: '075c27741a3506846368fa6e5b3477f85b31ceee71a5716e2f12b40fa21d23aa',
            data: 'Second block MODIFIED'
          )
        )
        blockchain.append(
          Block.new(
            index: 2,
            timestamp: 1_633_173_565,
            previous_hash: '5b781b11ade2d9f65010e18aaf809d67a37757af5173aa6f8385de19cb5d71e6',
            data: 'Third block'
          )
        )
      end

      it 'invalidates blockchain' do
        expect(blockchain.valid?).to be false
      end
    end

    context 'invalid blockchain (wrong indexes)' do
      before do
        blockchain.append(
          Block.new(
            index: 1,
            timestamp: 1_633_173_441,
            previous_hash: '075c27741a3506846368fa6e5b3477f85b31ceee71a5716e2f12b40fa21d23aa',
            data: 'Second block'
          )
        )
        blockchain.append(
          Block.new(
            index: 3,
            timestamp: 1_633_173_565,
            previous_hash: '5b781b11ade2d9f65010e18aaf809d67a37757af5173aa6f8385de19cb5d71e6',
            data: 'Third block'
          )
        )
      end

      it 'invalidates blockchain' do
        expect(blockchain.valid?).to be false
      end
    end
  end
end
