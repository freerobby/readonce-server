require 'rubygems'
require 'bundler'

Bundler.setup

require File.join(File.dirname(__FILE__), 'app')
run App.new
