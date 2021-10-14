# frozen_string_literal: true

require './lib/block'
require './lib/p2p'

class Blockchain
  attr_reader :blocks, :difficulty, :p2p

  def initialize(blocks: [genesis_block], difficulty: 4)
    @blocks = blocks
    @difficulty = difficulty
    @p2p = P2P.new
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
      block = Block.new(last_block.index + 1, Time.now.to_i, nonce, last_block.hash, data)
      return block if block.hash.start_with?('0' * difficulty)

      nonce += 1
    end
  end

  def add_peers(urls)
    p2p.add_peers(urls)
  end

  def broadcast_sync
    p2p.broadcast_sync
  end

  def replace_chain
    longest_chain_from_peers = p2p.longest_chain_from_peers
    @blocks = longest_chain_from_peers if longest_chain_from_peers.length > length
  end

  def to_h
    blocks.map(&:to_h)
  end

  private

  def genesis_block
    Block.new(0, Time.now.to_i, 0, '', 'Genesis Block')
  end

  def block_valid?(current, previous)
    current_hash = Block.compute_hash(current.index, current.timestamp, current.nonce,
                                      current.previous_hash, current.data)
    return false if current.hash != current_hash
    return false if current.index != previous.index + 1
    return false if current.previous_hash != previous.hash

    true
  end
end
