# frozen_string_literal: true

require 'sinatra'
require './lib/blockchain'

class SinatraApp < Sinatra::Base
  attr_reader :blockchain

  def initialize
    super
    @blockchain = Blockchain.new
  end

  get '/blocks' do
    blockchain.blocks.map(&:to_h).to_json
  end

  post '/mine' do
    request.body.rewind
    body = JSON.parse(request.body.read)
    data = body['data']
    next_block = blockchain.mine_block(data: data)
    blockchain.append(next_block)
    blockchain.broadcast_sync
    next_block.to_h.to_json
  end

  get '/peers' do
    blockchain.peers.to_json
  end

  post '/add_peer' do
    request.body.rewind
    body = JSON.parse(request.body.read)
    url = body['url']
    blockchain.add_peer(url)
  end

  post '/sync' do
    blockchain.sync_from_peers
    blockchain.blocks.map(&:to_h).to_json
  end
end
