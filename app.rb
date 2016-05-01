require 'sinatra'

class App < Sinatra::Base
  get '/' do
    'Please use the command line client.'
  end
end
