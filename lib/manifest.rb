class ArticleManifest

  def self.manifest; @@manifest ||= []; end

  def self.article(path, name)
    manifest.detect { |article| article.called?(path, name) }
  end

  def self.directory(path, name)
    articles = manifest.select { |article| article.in?([path, name].join('/')) }
    return nil if articles.empty?
    ArticleDirectory.new(name, articles)
  end

  def self.latest
    ArticleDirectory.new("Riding the Long Bus", manifest.first(10))
  end

  def self.add(path, name) manifest << Article.new(path, name); end
end

# Order is important here :)
ArticleManifest.add('/life', 'obama-and-einstein')
ArticleManifest.add('/code/ruby', 'rails-2_2-headaches-1')
ArticleManifest.add('/code/erlang', 'erlang-diaries-vol1')
ArticleManifest.add('/code', 'history-blog-meme')
ArticleManifest.add('/code/ruby', 'should-making-dry-even-dryier')
ArticleManifest.add('/life', 'me-me-meme')
ArticleManifest.add('/code/ruby', 'dumb-smtp')
ArticleManifest.add('/code/ruby', 'canonical')
ArticleManifest.add('/code/ruby', 'smurf-rails-autominifying-js-css-plugin')
ArticleManifest.add('/life', 'i-voted-2008')
ArticleManifest.add('/life', 'call-for-less-process')
ArticleManifest.add('/life', 'psa-illinois-sticker-renewal')
ArticleManifest.add('/code/ruby', 'rails-2-1-1-address-inflection')
ArticleManifest.add('/code/ruby', 'install-mysql-gem-on-mac')
ArticleManifest.add('/life', 'universal-quotes')
ArticleManifest.add('/code/ruby', 'sinatra-autohandling-css')
ArticleManifest.add('/code/ruby', 'rails-2-1-session-testing')
ArticleManifest.add('/life', 'summer-reading-08')
ArticleManifest.add('/work', 'joy-is-no-cubicles')
ArticleManifest.add('/code/ruby', 'mash-maker')
ArticleManifest.add('/code/ruby', 'json-in-rails-just-annoyed-me')
ArticleManifest.add('/life', 'only-losers-are-unc-fans')
ArticleManifest.add('/code/ruby', 'multiplexing-delegator')
ArticleManifest.add('/code', 'beautiful-code-readability-performance')
ArticleManifest.add('/life', 'active-record-modeling-life')
ArticleManifest.add('/code/ruby', 'flashback')
ArticleManifest.add('/code/ruby', 'assert-session-extending-assert-request')
ArticleManifest.add('/code/ruby', 'full-on-errors')
ArticleManifest.add('/code', 'password-sophistication')
