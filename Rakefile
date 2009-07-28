require 'rubygems'
require 'rake'

desc "Generate sitemap"
task :sitemap do
  %x[find _site -name "*.html" | cut -c 6- > sitemap.txt]
  %x[cp sitemap.txt _site/]
end
