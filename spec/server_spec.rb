# frozen_string_literal: true

require 'rack/test'
require './lib/server'

describe 'Sinatra App' do
  include Rack::Test::Methods

  def app
    SinatraApp.new
  end

  describe '/blocks' do
    it 'returns list of blocks' do
      get '/blocks'

      body = JSON.parse(last_response.body)

      expect(body).to be_an(Array)
      expect(body[0]['index']).to eq(0)
    end
  end

  describe '/mine' do
    it 'returns a new mined block' do
      post '/mine', '{ "data": "block" }', { 'CONTENT_TYPE' => 'application/json' }

      body = JSON.parse(last_response.body)
      expect(body['data']).to eq('block')
    end
  end

  describe '/add_peer' do
    let(:url) { 'http://host:port' }

    it 'adds the new peer' do
      post '/add_peer', { url: url }.to_json, { 'CONTENT_TYPE' => 'application/json' }

      body = JSON.parse(last_response.body)
      expect(body['url']).to eq(url)
    end
  end
end
