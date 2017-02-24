# frozen_string_literal: true
require 'bundler'
require 'json'
Bundler.require
Loader.autoload


require 'dotenv/load' if ENV['RACK_ENV'] == 'development'

class App < Rack::App
  headers 'Access-Control-Allow-Origin' => '*'

  # Events
  namespace '/events' do
    mount Events
  end

  root '/hello'
end
