# frozen_string_literal: true

require 'digest'

class Block
  attr_reader :index, :timestamp, :previous_hash, :data

  def initialize(index:, timestamp:, previous_hash:, data:)
    @index = index
    @timestamp = timestamp
    @previous_hash = previous_hash
    @data = data
  end

  def hash
    Digest::SHA2.new(256).hexdigest("#{index}#{previous_hash}#{data}")
  end
end
