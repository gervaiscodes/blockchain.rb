# frozen_string_literal: true

require 'p2p'

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
end
