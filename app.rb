require 'sinatra'

require_relative 'bag'

class App < Sinatra::Base
  get '/' do
    'Please use the command line client.'
  end

  post '/create' do
    bag = Bag.new
    bag.data = request.body.read
    bag.key
  end

  get '/status/*' do
    key = params[:splat][0]
    if Bag.find_by_key(key)
      status 200
      'Found'
    else
      status 404
      'Not found'
    end
  end

  get '/*' do
    key = params[:splat][0]
    if Bag.find_by_key(key)
      content_type 'text/plain'
      Bag.delete_by_key(key).data
    else
      status 404
      'Key not found or already read.'
    end
  end
end
