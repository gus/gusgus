def require_local_lib(pattern)
  Dir.glob(File.join(File.dirname(__FILE__), pattern)).each {|f| require f }
end

require 'rubygems'
require 'sinatra'
require 'bluecloth'
require 'syntaxi'
require 'ostruct'
require_local_lib('lib/*.rb')

configure do
  Syntaxi.wrap_enabled = false
  set_option :views, 
  set(:public, "#{Sinatra.application.options.root}/public")
  set(:views, "#{Sinatra.application.options.root}/views")
end

template(:layout) {:application}

not_found do
  @article = OpenStruct.new(:title => "Not Found")
  haml :not_found
end

get '/application.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :application
end

get '/' do
  @renderable = ArticleManifest.latest
  haml :directory
end

get '*/:name' do
  path = params['splat'].first
  name = params['name']
  if @renderable = ArticleManifest.article(path, name)
    haml :article
  elsif @renderable = ArticleManifest.directory(path, name)
    haml :directory
  else
    raise Sinatra::NotFound
  end
end
