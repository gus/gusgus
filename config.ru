ENV['APP_ENV'] ||= (ENV['RACK_ENV'] || 'production')

require 'rubygems'
require 'gusgus'

log = File.new("#{File.dirname(__FILE__)}/log/gusgus_#{Sinatra::Application.environment}.log", "a+")
STDOUT.reopen(log)
STDERR.reopen(log)

map "/" do
  run GusGus
end

