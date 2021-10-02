# frozen_string_literal: true

require 'sinatra'
require_relative 'blockchain'

blockchain = Blockchain.new

get '/blocks' do
  blockchain.blocks.map(&:to_h).to_json
end
