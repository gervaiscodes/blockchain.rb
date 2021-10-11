# frozen_string_literal: true

require 'net/http'
require './lib/block'

class Blockchain
  DIFFICULTY = 4

  attr_reader :blocks, :peers

  def initialize(blocks: [genesis_block])
    @blocks = blocks
    @peers = []
  end

  def length
    blocks.length
  end

  def last_block
    blocks.last
  end

  def block_at(index)
    blocks[index]
  end

  def append(block)
    blocks.push(block)
  end

  def valid?
    (length - 1).downto(1).each do |position|
      current = block_at(position)
      previous = block_at(position - 1)
      return false unless block_valid?(current, previous)
    end
    true
  end

  def mine_block(data:)
    nonce = 0
    loop do
      block = next_block(nonce: nonce, data: data)
      return block if block.hash.start_with?('0' * DIFFICULTY)

      nonce += 1
    end
  end

  def add_peer(url)
    peers.push(url)
  end

  def trigger_peers_sync
    peers.each do |peer|
      Net::HTTP.post(URI("#{peer}/sync"), "{}")
    end
  end

  def sync_from_peers
    longest_chain = nil
    peers.each do |peer|
      res = Net::HTTP.get(URI("#{peer}/blocks"))
      parsed = JSON.parse(res)
      blocks = parsed.map { |block| Block.from_hash(block) }
      chain = Blockchain.new(blocks: blocks)
      if chain.valid? && chain.length > length
        longest_chain = chain
      end
    end
    blocks = longest_chain.blocks if longest_chain
  end

  private

  def genesis_block
    Block.new(
      index: 0,
      timestamp: Time.now.to_i,
      nonce: 0,
      previous_hash: '',
      data: 'Genesis Block'
    )
  end

  def next_block(nonce:, data:)
    Block.new(
      index: last_block.index + 1,
      timestamp: Time.now.to_i,
      nonce: nonce,
      previous_hash: last_block.hash,
      data: data
    )
  end

  def block_valid?(current, previous)
    current_hash = Block.compute_hash(index: current.index, timestamp: current.timestamp,
                                      nonce: current.nonce, previous_hash: current.previous_hash,
                                      data: current.data)
    return false if current.hash != current_hash
    return false if current.index != previous.index + 1
    return false if current.previous_hash != previous.hash

    true
  end
end
