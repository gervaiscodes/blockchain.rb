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

  private

  def genesis_block
    Block.new(
      index: 0,
      timestamp: Time.now.to_i,
      nonce: 1,
      previous_hash: '',
      data: 'Genesis Block'
    )
  end
end
