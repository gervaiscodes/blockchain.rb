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
            nonce: 1,
            previous_hash: 'fbaf8efb574966243298f160491b36aea07e16341298beb586026a4fc90a6a70',
            data: 'Second block'
          )
        )
        blockchain.append(
          Block.new(
            index: 2,
            timestamp: 1_633_173_565,
            nonce: 2,
            previous_hash: '0eb60052dbd2c9b17bde623cc15e19710c189653f7c77b6c9921ab26729be3d8',
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
            nonce: '',
            previous_hash: 'fbaf8efb574966243298f160491b36aea07e16341298beb586026a4fc90a6a70',
            data: 'Second block MODIFIED'
          )
        )
        blockchain.append(
          Block.new(
            index: 2,
            timestamp: 1_633_173_565,
            nonce: '',
            previous_hash: '0eb60052dbd2c9b17bde623cc15e19710c189653f7c77b6c9921ab26729be3d8',
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
            nonce: '',
            previous_hash: 'fbaf8efb574966243298f160491b36aea07e16341298beb586026a4fc90a6a70',
            data: 'Second block'
          )
        )
        blockchain.append(
          Block.new(
            index: 3,
            timestamp: 1_633_173_565,
            nonce: '',
            previous_hash: '0eb60052dbd2c9b17bde623cc15e19710c189653f7c77b6c9921ab26729be3d8',
            data: 'Third block'
          )
        )
      end

      it 'invalidates blockchain' do
        expect(blockchain.valid?).to be false
      end
    end
  end

  describe 'block mining' do
    let(:data) { 'block' }
    let(:block) { blockchain.mine_block(data: data) }

    it 'computes hash with correct difficulty' do
      expect(block.hash).to start_with('0' * Blockchain::DIFFICULTY)
    end

    it 'sets correct attributes of the new block' do
      expect(block.index).to eq(blockchain.last_block.index + 1)
      expect(block.previous_hash).to eq(blockchain.last_block.hash)
      expect(block.data).to eq(data)
    end
  end

  describe 'appending a new block to the chain' do
    let(:data) { 'block' }
    let(:block) { blockchain.mine_block(data: data) }

    before do
      blockchain.append(block)
    end

    it 'appends a new mined block to the chain' do
      expect(blockchain.last_block.hash).to eq(block.hash)
    end

    it 'results in a valid chain' do
      expect(blockchain.valid?).to be(true)
    end
  end
end
