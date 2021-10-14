# frozen_string_literal: true

require 'p2p'
require 'blockchain'

RSpec.describe P2P do
  let(:p2p) do
    P2P.new
  end
  let(:url) { 'http://host:8888' }

  describe 'add_peer' do
    before do
      p2p.add_peer(url)
    end

    it 'adds url to peers' do
      expect(p2p.peers).to include(url)
    end
  end

  describe 'broadcast_sync' do
    before do
      peers.each do |url|
        stub_request(:post, "#{url}/sync")
        p2p.add_peer(url)
      end
    end

    context 'with peers' do
      let(:peers) { ['http://host:7777', 'http://host:8888'] }

      it 'request other peers blocks' do
        thread = p2p.broadcast_sync
        thread.join

        peers.each do |url|
          assert_requested :post, "#{url}/sync"
        end
      end
    end

    context 'without peer' do
      let(:peers) { [] }

      it 'does not perform any request' do
        expect_any_instance_of(Net::HTTP).not_to receive(:post)

        thread = p2p.broadcast_sync
        thread.join
      end
    end
  end

  describe 'longest_chain_from_peers' do
    let(:peers) do
      [{
        url: 'http://host:7777',
        blocks: DummyBlockchainFactory.new(3).call.blocks.map(&:to_h).to_json
      }, {
        url: 'http://host:8888',
        blocks: DummyBlockchainFactory.new(8).call.blocks.map(&:to_h).to_json
      }, {
        url: 'http://host:9999',
        blocks: DummyBlockchainFactory.new(4).call.blocks.map(&:to_h).to_json
      }]
    end

    before do
      peers.each do |peer|
        stub_request(:get, "#{peer[:url]}/blocks").to_return(body: peer[:blocks])
        p2p.add_peer(peer[:url])
      end
    end

    it 'gets the longest chain from peers' do
      expect(p2p.longest_chain_from_peers.length).to eq(8)
    end
  end
end

class DummyBlockchainFactory
  attr_reader :length, :blockchain

  def initialize(length)
    @length = length
    @blockchain = Blockchain.new
  end

  def call
    (1...length).each do |position|
      block = blockchain.mine_block(data: position)
      blockchain.append(block)
    end
    blockchain
  end
end
