class Article
  def self.article_path(path, name)
    File.join('articles', path, name + '.markdown')
  end
  
  def initialize(path, name)
    @path = path
    @name = File.basename(name, '.markdown')
    @filename = Article.article_path(@path, @name)
    @content = File.read(@filename)
  end

  def commentable?; true; end

  def called?(path, name)
    [@path, @name] == [path, name]
  end

  def in?(path) @path == path; end

  def urn; [@path, @name].join('/'); end

  def title
    @content.scan(/.+/).first.gsub(/^[\#\s]*/, '')
  end

  def render(opts={})
    article = @content
    if opts[:excerpt]
      if article =~ /\[excerpt\].+\[\/excerpt\]/m
        article = @content.scan(/\[excerpt\].+\[\/excerpt\]/m).first
      else
        if article.length > 500
          article = @content.scan(/^.+$/)[2..3].join("\n\n")
        else
          article = @content.scan(/.+\n/)[2..-1].join('')
        end
      end
    end
    article.gsub!(/\[\/?excerpt\]/, '')
    BlueCloth.new(Syntaxi.new(article).process).to_html
  end
end

