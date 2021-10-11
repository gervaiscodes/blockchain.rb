# frozen_string_literal: true

require './lib/block'

class Blockchain
  DIFFICULTY = 4

  attr_reader :blocks

  def initialize(blocks: [genesis_block])
    @blocks = blocks
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
    (1...length).each do |position|
      previous_block = block_at(position - 1)
      current_block = block_at(position)
      return false unless valid_new_block?(previous_block, current_block)
    end
    true
  end

  def valid_new_block?(previous_block, current_block)
    current_hash = Block.compute_hash(index: current_block.index, timestamp: current_block.timestamp,
                                      nonce: current_block.nonce, previous_hash: current_block.previous_hash,
                                      data: current_block.data)
    return false if current_block.hash != current_hash
    return false if current_block.index != previous_block.index + 1
    return false if current_block.previous_hash != previous_block.hash

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
end
