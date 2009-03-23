def require_local_lib(pattern)
  Dir.glob(File.join(File.dirname(__FILE__), pattern)).each {|f| require f }
end

require 'rubygems'
require 'sinatra/base'
require 'bluecloth'
require 'syntaxi'
require 'ostruct'
require 'chicago'
require_local_lib('lib/*.rb')

class GusGus < Sinatra::Base
  register Sinatra::ThumbleMonks::Base
  helpers Sinatra::ThumbleMonks::Helpers

  configure do
    Syntaxi.wrap_enabled = false
  end

  # Helpers
  def url_to(path)
    host = (request.env['HTTP_HOST'] || request.env['SERVER_NAME'] || 'gusg.us')
    request.env['rack.url_scheme'] + "://" + host + path
  end

  def rfc822; Time.now.strftime("%a, %d %b %Y %H:%M:%S %Z"); end

  # Catch alls
  catch_all_css

  not_found do
    @article = OpenStruct.new(:title => "Not Found")
    haml :not_found
  end

  # Main app
  get '/application.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :application
  end

  get '/' do
    @renderable = ArticleManifest.latest
    haml :directory, :layout => :application
  end

  get '/feed.xml' do
    content_type 'text/xml', :charset => 'utf-8'
    @renderable = ArticleManifest.latest
    haml :feed, :layout => false
  end

  get '*/:name' do
    path = params['splat'].first
    name = params['name']
    if @renderable = ArticleManifest.article(path, name)
      haml :article, :layout => :application
    elsif @renderable = ArticleManifest.directory(path, name)
      haml :directory, :layout => :application
    else
      raise Sinatra::NotFound
    end
  end
end
