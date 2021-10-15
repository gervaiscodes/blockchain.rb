# frozen_string_literal: true

require 'sinatra'
require './lib/blockchain'

class SinatraApp < Sinatra::Base
  attr_reader :blockchain

  def initialize
    super
    @blockchain = Blockchain.new
  end

  before do
    content_type :json
  end

  get '/blocks' do
    blockchain.to_h.to_json
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
    blockchain.p2p.peers.to_json
  end

  post '/add_peers' do
    request.body.rewind
    body = JSON.parse(request.body.read)
    urls = body['urls']
    blockchain.add_peers(urls)
    { urls: urls }.to_json
  end

  post '/sync' do
    blockchain.replace_chain
  end
end
