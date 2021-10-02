# frozen_string_literal: true

require_relative 'block'

class Blockchain
  attr_reader :chain

  def initialize
    @chain = [genesis_block]
  end

  def length
    chain.length
  end

  def last_block
    chain.last
  end

  def block_at(index)
    chain[index]
  end

  def append(block)
    chain.push(block)
  end

  def valid?
    (1...length).each do |position|
      previous_block = block_at(position - 1)
      current_block = block_at(position)
      return false if current_block.index != previous_block.index + 1
      return false if current_block.previous_hash != previous_block.hash
    end
    true
  end

  def next_block(data:)
    Block.new(
      index: last_block.index + 1,
      timestamp: Time.now.to_i,
      previous_hash: last_block.hash,
      data: data
    )
  end

  private

  def genesis_block
    Block.new(
      index: 0,
      timestamp: Time.now.to_i,
      previous_hash: '',
      data: 'Genesis Block'
    )
  end
end
