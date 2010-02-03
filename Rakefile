require 'rubygems'
require 'rake'

namespace :sitemap do
  desc "Ping Google with the latest sitemap"
  task :ping do
    require 'cgi'
    sitemap_url = CGI.escape("http://gusg.us/sitemap.xml")
    %x[curl -s -S "http://www.google.com/webmasters/tools/ping?sitemap=#{sitemap_url}"]
    puts "Pinged google"
    %x[curl -s -S "http://feedburner.google.com/fb/a/pingSubmit?bloglink=http://gusg.us/"]
    puts "Pinged feedburner"
    # %x[curl -s -S "http://search.yahooapis.com/SiteExplorerService/V1/ping?sitemap=#{sitemap_url}"]
    # puts "Pinged yahoo"
    # %x[curl -s -S "http://www.bing.com/webmaster/ping.aspx?siteMap=#{sitemap_url}"]
    # puts "Pinged bing"
  end
end
