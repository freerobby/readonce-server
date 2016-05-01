require File.join(File.dirname(__FILE__), '..', 'app')

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
    it 'creates file with body as contents and returns key' do
      post '/create', 'testing123'
      key = last_response.body
      expect(App.class_eval('@@files')[key]).to eql('testing123')
    end
  end

  describe 'GET /*' do
    it 'loads file and deletes it' do
      post '/create', 'testing123'
      key = last_response.body
      get "/#{key}"
      expect(last_response.body).to eql('testing123')
      get "/#{key}"
      expect(last_response.body).not_to eql('testing123')
    end
  end
end
