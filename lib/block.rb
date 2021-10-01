# frozen_string_literal: true

class Block
  attr_reader :index, :timestamp, :nonce, :previous_hash, :data

  def initialize(index:, timestamp:, nonce:, previous_hash:, data:)
    @index = index
    @timestamp = timestamp
    @nonce = nonce
    @previous_hash = previous_hash
    @data = data
  end
end
