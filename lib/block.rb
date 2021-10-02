# frozen_string_literal: true

require 'digest'

class Block
  attr_reader :index, :timestamp, :nonce, :previous_hash, :data

  def initialize(index:, timestamp:, nonce:, previous_hash:, data:)
    @index = index
    @timestamp = timestamp
    @nonce = nonce
    @previous_hash = previous_hash
    @data = data
  end

  def hash
    Digest::SHA2.new(256).hexdigest("#{index}#{timestamp}#{nonce}#{previous_hash}#{data}")
  end

  def to_h
    {
      index: index,
      timestamp: timestamp,
      nonce: nonce,
      previous_hash: previous_hash,
      hash: hash,
      data: data
    }
  end
end
