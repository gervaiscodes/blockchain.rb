# frozen_string_literal: true

class Block
  attr_reader :index, :timestamp, :previous_hash, :data

  def initialize(index:, timestamp:, previous_hash:, data:)
    @index = index
    @timestamp = timestamp
    @previous_hash = previous_hash
    @data = data
  end
end
