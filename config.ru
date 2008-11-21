require 'rubygems'
require 'rack'
require 'sinatra'

Sinatra::Application.default_options.update(
  :run => false,
  :env => :production,
  :raise_errors => true,
  :root => File.dirname(__FILE__)
)

log = File.new("#{File.dirname(__FILE__)}/log/gusgus_#{Sinatra.application.options.env}.log", "a+")
STDOUT.reopen(log)
STDERR.reopen(log)

require 'gusgus'

run Sinatra.application
