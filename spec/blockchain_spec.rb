# frozen_string_literal: true

require 'blockchain'
require 'timecop'

RSpec.describe Blockchain do
  let(:blockchain) do
    Timecop.freeze(Time.utc(2008, 8, 8, 8, 8, 8))
    blockchain = Blockchain.new
    Timecop.return
    blockchain
  end

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
            previous_hash: '0f60acf762e19d1ef28979b558dea42e10eb1c1e736f5d6bb478ae9e928812e9',
            data: 'Second block'
          )
        )
        blockchain.append(
          Block.new(
            index: 2,
            timestamp: 1_633_173_565,
            previous_hash: '8ead48f1fca4a6e6e5d76fc5308126020ff448fdac4dd2275b27c8a141f8cfea',
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
            previous_hash: '0f60acf762e19d1ef28979b558dea42e10eb1c1e736f5d6bb478ae9e928812e9',
            data: 'Second block MODIFIED'
          )
        )
        blockchain.append(
          Block.new(
            index: 2,
            timestamp: 1_633_173_565,
            previous_hash: '8ead48f1fca4a6e6e5d76fc5308126020ff448fdac4dd2275b27c8a141f8cfea',
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
            previous_hash: '0f60acf762e19d1ef28979b558dea42e10eb1c1e736f5d6bb478ae9e928812e9',
            data: 'Second block'
          )
        )
        blockchain.append(
          Block.new(
            index: 3,
            timestamp: 1_633_173_565,
            previous_hash: '8ead48f1fca4a6e6e5d76fc5308126020ff448fdac4dd2275b27c8a141f8cfea',
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
