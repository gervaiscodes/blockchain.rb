# frozen_string_literal: true

require 'sinatra'
require_relative 'blockchain'

blockchain = Blockchain.new

get '/blocks' do
  blockchain.blocks.map(&:to_h).to_json
end

post '/mine' do
  request.body.rewind
  body = JSON.parse(request.body.read)
  data = body['data']
  next_block = blockchain.mine_block(data: data)
  blockchain.append(next_block)
  next_block.to_h.to_json
end
