# frozen_string_literal: true

require 'block'

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

  def add_block(block)
    chain.push(block)
  end

  def valid?
    (1...length).each do |position|
      previous_block = block_at(position - 1)
      current_block = block_at(position)
      return false if current_block.previous_hash != previous_block.hash
    end
    true
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
