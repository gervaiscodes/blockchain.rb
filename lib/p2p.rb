# frozen_string_literal: true

require 'net/http'

class P2P
  attr_reader :peers

  def initialize
    @peers = []
  end

  def add_peer(url)
    peers.push(url)
  end

  def broadcast_sync
    Thread.new do
      peers.each do |url|
        Net::HTTP.post(URI("#{url}/sync"), '')
      end
    end
  end

  def longest_chain_from_peers
    peers.each_with_object([]) do |url, longest|
      res = Net::HTTP.get(URI("#{url}/blocks"))
      parsed = JSON.parse(res)
      chain = Blockchain.new(blocks: parsed.map { |block| Block.from_hash(block) })
      return chain.blocks if chain.length > longest.length && chain.valid?
    end
  end
end
