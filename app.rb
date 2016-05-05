require 'sinatra'

require 'json'

require_relative 'bag'

class App < Sinatra::Base
  MINIMUM_RUBY_CLIENT_VERSION = '1.0.9'

  get '/' do
    'Please use the command line client.'
  end

  post '/create' do
    content_type 'text/plain'
    bag = Bag.new
    bag.data = request.body.read
    bag.key
  end

  get '/status/*' do
    content_type 'text/plain'
    key = params[:splat][0]
    if bag = Bag.find_by_key(key)
      status 200
      {
        'accessed_at' => bag.accessed_at,
        'accessed_by_ip' => bag.accessed_by_ip
      }.to_json
    else
      status 404
      'Not found'
    end
  end

  get '/minimum-ruby-client-version' do
    MINIMUM_RUBY_CLIENT_VERSION
  end

  get '/*' do
    content_type 'text/plain'
    key = params[:splat][0]
    if bag = Bag.find_by_key(key)
      if bag.accessed_at
        status 410 # Gone
        "This bag was accessed at #{bag.accessed_at} by IP address #{bag.accessed_by_ip}.\nIf that's not what you were expecting, you should assume it was compromised."
      else
        status 200
        bag.accessed_at = Time.now
        bag.accessed_by_ip = request.ip
        data = bag.data
        bag.data = nil
        data
      end
    else
      status 404
      'Key not found or server restarted since it was created.'
    end
  end
end
