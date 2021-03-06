require_relative '../app'

require 'spec_helper'
require 'rack/test'

RSpec.describe App do
  include Rack::Test::Methods

  def app
    @app ||= App.new
  end

  describe 'GET /' do
    it 'responds with 200' do
      get '/'
      expect(last_response).to be_ok
    end
  end

  describe 'POST /create' do
    it 'creates bag with body as contents and returns key' do
      post '/create', 'testing123'
      key = last_response.body
      expect(Bag.find_by_key(key).data).to eql('testing123')
    end
  end

  describe 'GET /*' do
    it 'loads bag and deletes it' do
      post '/create', 'testing123'
      key = last_response.body
      get "/#{key}"
      expect(last_response.body).to eql('testing123')
      expect(last_response.status).to eql(200)
      get "/#{key}"
      expect(last_response.body).not_to eql('testing123')
      expect(last_response.status).to eql(410)
    end

    it 'refuses Slack requests' do
      post '/create', 'testing123'
      key = last_response.body
      get "/#{key}", {}, {"HTTP_USER_AGENT" => "Slackbot 1.0(+https://api.slack.com/robots)"}
      expect(last_response.body).to eql('Forbidden')
      expect(last_response.status).to eql(403)
      get "/#{key}"
      expect(last_response.body).to eql('testing123')
      expect(last_response.status).to eql(200)
      get "/#{key}"
      expect(last_response.body).not_to eql('testing123')
      expect(last_response.status).to eql(410)
    end
  end

  describe 'GET /minimum-ruby-client-version' do
    it 'returns specified minimum version' do
      get '/minimum-ruby-client-version'
      expect(last_response.body).to eql(App::MINIMUM_RUBY_CLIENT_VERSION)
    end
  end

  describe 'GET /status/*' do
    it 'returns 200 if key exists' do
      post '/create', 'testing123'
      key = last_response.body
      get "/status/#{key}"
      expect(last_response.status).to eql(200)
    end
    it 'returns 200 if key has been used' do
      post '/create', 'testing123'
      key = last_response.body
      get "#{key}"
      get "/status/#{key}"
      expect(last_response.status).to eql(200)
    end
    it 'returns 404 if key never existed' do
      get "/status/foo"
      expect(last_response.status).to eql(404)
    end
  end
end
