# frozen_string_literal: true

require 'net/http'

class P2P
  attr_reader :peers

  def initialize
    @peers = []
  end

  def add_peers(urls)
    peers.concat(urls)
  end

  def broadcast_sync
    Thread.new do
      peers.each do |url|
        Net::HTTP.post(URI("#{url}/sync"), '')
      end
    end
  end

  def longest_chain_from_peers
    peers.inject([]) do |longest, url|
      res = Net::HTTP.get(URI("#{url}/blocks"))
      parsed = JSON.parse(res)
      chain = Blockchain.new(blocks: parsed.map { |block| Block.from_hash(block) })
      chain.length > longest.length && chain.valid? ? chain.blocks : longest
    end
  end
end
