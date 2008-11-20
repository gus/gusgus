require 'rubygems'
require 'sinatra'
require 'BlueCloth'
require 'syntaxi'

configure do
  Syntaxi.wrap_enabled = false
end

template(:layout) {:application}
not_found {haml :not_found}

get '/application.css' do
  sass :application
end

get '/' do
  @title = "Hello"
  haml :index
end

get '*/:name' do
  path = params['splat']
  name = params['name']
  if ArticleDirectory.handles_request?(path, name)
    @directory = ArticleDirectory.new(path, name)
    haml :directory
  elsif Article.handles_request?(path, name)
    @article = Article.new(path, name)
    haml :article
  else
    raise Sinatra::NotFound
  end
end

# Models and stuff

class ArticleDirectory
  def self.directory_path(path, name)
    File.join('articles', path, name)
  end

  def self.handles_request?(path, name)
    File.directory?(directory_path(path, name))
  end

  def initialize(path, name)
    @path = path
    @name = name
  end

  def title
    @name.gsub(/[_-]+/, ' ').split.map{|w| w.capitalize}.join(' ')
  end

  def articles
    Dir.glob(File.join('articles', @path, @name, '*.markdown')).map do |filename|
      path = [@path, @name].join('/')
      Article.new(path, filename, :excerpt => true)
    end
  end
end

class Article
  def self.article_path(path, name)
    File.join('articles', path, name + '.markdown')
  end

  def self.handles_request?(path, name)
    File.exists?(article_path(path, name))
  end
  
  def initialize(path, name, opts={})
    @path = path
    @name = File.basename(name, '.markdown')
    @filename = Article.article_path(@path, @name)
    @options = opts
    @content = File.read(@filename)
  end
  def urn
    [@path, @name].join('/')
  end

  def title
    @content.scan(/.+/).first.gsub(/^[\#\s]*/, '')
  end

  def render
    article = @content
    if @options[:excerpt]
      if article.length > 500
        article = @content.scan(/^.+$/)[2..3].join("\n\n")
      else
        article = @content.scan(/.+\n/)[2..-1].join('')
      end
    end
    BlueCloth.new(Syntaxi.new(article).process).to_html
  end
end
