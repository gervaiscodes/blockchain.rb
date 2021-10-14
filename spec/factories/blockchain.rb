# frozen_string_literal: true

class BlockchainFactory
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
