class ArticleDirectory
  attr_reader :articles

  def initialize(name, articles)
    @name = name
    @articles = articles
  end

  def commentable?; false; end

  def title
    @name.gsub(/[_-]+/, ' ').split.map{|w| w.capitalize}.join(' ')
  end
end

