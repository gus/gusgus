require 'rubygems'
require 'rack'
require 'sinatra'

set :environment, :production
set :root, File.dirname(__FILE__)
set :raise_errors, true
disable :run

log = File.new("#{File.dirname(__FILE__)}/log/gusgus_#{Sinatra::Application.environment}.log", "a+")
STDOUT.reopen(log)
STDERR.reopen(log)

require 'gusgus'

map "/" do
  run GusGus
end

