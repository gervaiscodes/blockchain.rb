# frozen_string_literal: true

require 'json'
require 'digest'

class Block
  attr_reader :index, :timestamp, :nonce, :previous_hash, :data, :hash

  def initialize(index, timestamp, nonce, previous_hash, data)
    @index = index
    @timestamp = timestamp
    @nonce = nonce
    @previous_hash = previous_hash
    @data = data
    @hash = Block.compute_hash(index, timestamp, nonce, previous_hash, data)
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

  def self.from_hash(hash)
    Block.new(hash['index'], hash['timestamp'], hash['nonce'], hash['previous_hash'], hash['data'])
  end

  def self.compute_hash(index, timestamp, nonce, previous_hash, data)
    Digest::SHA2.new(256).hexdigest("#{index}#{timestamp}#{nonce}#{previous_hash}#{data}")
  end
end
