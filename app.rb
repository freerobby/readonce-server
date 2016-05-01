require 'sinatra'

class App < Sinatra::Base
  configure do
    @@files = {}
  end

  get '/' do
    'Please use the command line client.'
  end

  post '/create' do
    key = SecureRandom.hex
    @@files[key] = request.body.read
    key
  end

  get '/*' do
    key = params[:splat][0]
    if @@files[key]
      @@files.delete(key)
    else
      status 400
      'Key not found or already read.'
    end
  end
end
