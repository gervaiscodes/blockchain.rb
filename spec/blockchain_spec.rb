# frozen_string_literal: true

require 'blockchain'
require 'timecop'

RSpec.describe Blockchain do
  let(:difficulty) { 2 }
  let(:blockchain) do
    Timecop.freeze(Time.utc(2008, 8, 8, 8, 8, 8))
    blockchain = Blockchain.new(difficulty: difficulty)
    Timecop.return
    blockchain
  end

  describe 'initialize' do
    it 'creates genesis block' do
      expect(blockchain.length).to eq(1)
      expect(blockchain.last_block.index).to eq(0)
      expect(blockchain.last_block.previous_hash).to eq('')
    end
  end

  describe 'valid?' do
    let(:block1_index) { 1 }
    let(:block2_index) { 2 }
    let(:block1_previous_hash) { 'fbaf8efb574966243298f160491b36aea07e16341298beb586026a4fc90a6a70' }
    let(:block2_previous_hash) { '0eb60052dbd2c9b17bde623cc15e19710c189653f7c77b6c9921ab26729be3d8' }
    let(:block1_data) { 'Second block' }
    let(:block2_data) { 'Third block' }
    let(:block1) do
      Block.new(block1_index, 1_633_173_441, 1, block1_previous_hash, block1_data)
    end
    let(:block2) do
      Block.new(block2_index, 1_633_173_565, 2, block2_previous_hash, block2_data)
    end

    before do
      blockchain.append(block1)
      blockchain.append(block2)
    end

    context 'valid blockchain' do
      it 'validates blockchain' do
        expect(blockchain.valid?).to be true
      end
    end

    context 'invalid blockchain (wrong data)' do
      let(:block1_data) { 'Second block MODIFIED' }

      it 'invalidates blockchain' do
        expect(blockchain.valid?).to be false
      end
    end

    context 'invalid blockchain (wrong hash)' do
      let(:block2_previous_hash) { '0000' }

      it 'invalidates blockchain' do
        expect(blockchain.valid?).to be false
      end
    end

    context 'invalid blockchain (wrong indexes)' do
      let(:block2_index) { 3 }

      it 'invalidates blockchain' do
        expect(blockchain.valid?).to be false
      end
    end
  end

  describe 'mine_block' do
    let(:difficulty) { 3 }
    let(:data) { 'block' }
    let(:block) { blockchain.mine_block(data: data) }

    it 'computes hash with correct difficulty' do
      expect(block.hash).to start_with('0' * difficulty)
    end

    it 'sets correct attributes of the new block' do
      expect(block.index).to eq(blockchain.last_block.index + 1)
      expect(block.previous_hash).to eq(blockchain.last_block.hash)
      expect(block.data).to eq(data)
    end
  end

  describe 'append' do
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

  describe 'replace_chain' do
    let(:peers) do
      [{
        url: 'http://host:7777',
        blocks: BlockchainFactory.new(3).call.blocks.map(&:to_h).to_json
      }, {
        url: 'http://host:8888',
        blocks: BlockchainFactory.new(8).call.blocks.map(&:to_h).to_json
      }, {
        url: 'http://host:9999',
        blocks: BlockchainFactory.new(4).call.blocks.map(&:to_h).to_json
      }]
    end

    before do
      blockchain.p2p.add_peers(peers.map { |peer| peer[:url] })
      peers.each do |peer|
        stub_request(:get, "#{peer[:url]}/blocks").to_return(body: peer[:blocks])
      end
    end

    context 'when a peer has a longer chain' do
      let(:blockchain) { BlockchainFactory.new(20).call }

      it 'keeps the current chain unchanged' do
        expect(blockchain.length).to eq(20)
        blockchain.replace_chain
        expect(blockchain.length).to eq(20)
      end
    end

    context 'when no peer has a longer chain' do
      it 'replaces the current chain with the longest one from peers' do
        expect(blockchain.length).to eq(1)
        blockchain.replace_chain
        expect(blockchain.length).to eq(8)
      end
    end
  end
end
