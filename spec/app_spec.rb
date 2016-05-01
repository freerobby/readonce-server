require File.join(File.dirname(__FILE__), '..', 'app')

require 'spec_helper'
require 'rack/test'

RSpec.describe App do
  include Rack::Test::Methods

  def app
    App.new
  end

  describe 'GET /' do
    it 'responds with 200' do
      get '/'
      expect(last_response).to be_ok
    end
  end
end
