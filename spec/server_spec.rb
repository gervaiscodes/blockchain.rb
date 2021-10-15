# frozen_string_literal: true

require 'rack/test'
require './lib/server'

describe 'Sinatra App' do
  include Rack::Test::Methods

  def app
    SinatraApp.new
  end

  let(:urls) { ['http://host:8888'] }

  before do
    urls.each do |url|
      stub_request(:get, "#{url}/blocks").to_return(body: '[]')
    end
  end

  describe '/blocks' do
    it 'returns list of blocks' do
      get '/blocks'

      body = JSON.parse(last_response.body)

      expect(last_response.status).to eq(200)
      expect(body).to be_an(Array)
      expect(body[0]['index']).to eq(0)
    end
  end

  describe '/mine' do
    it 'returns a new mined block' do
      post '/mine', '{ "data": "block" }', { 'CONTENT_TYPE' => 'application/json' }

      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
      expect(body['data']).to eq('block')
    end
  end

  describe '/add_peers' do
    it 'adds the new peer' do
      post '/add_peers', { urls: urls }.to_json, { 'CONTENT_TYPE' => 'application/json' }

      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
      expect(body['urls']).to eq(urls)
    end
  end

  describe '/peers' do
    context 'without peers' do
      it 'returns no peer' do
        get '/peers'

        body = JSON.parse(last_response.body)
        expect(last_response.status).to eq(200)
        expect(body).to match_array([])
      end
    end

    context 'with peers' do
      before do
        post '/add_peers', { urls: urls }.to_json, { 'CONTENT_TYPE' => 'application/json' }
      end

      it 'returns the peers' do
        get '/peers'

        body = JSON.parse(last_response.body)
        expect(last_response.status).to eq(200)
        expect(body).to match_array(urls)
      end
    end
  end

  describe '/sync' do
    before do
      post '/add_peers', { urls: urls }.to_json, { 'CONTENT_TYPE' => 'application/json' }
    end

    it 'syncs the current node with the peers' do
      post '/sync'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to be_empty
    end
  end
end
