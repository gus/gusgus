function jsonFlickrFeed(data) {
  var list = $$(".flickr").first();
  $(data.items).each(function(item) {
    var image_url = item.media.m.replace(/_m\.jpg$/, "_s.jpg");
    var image = new Element("img", {src: image_url});
    var link = new Element("a", {href: item.link}).update(image);
    var list_item = new Element("li").update(link);
    list.insert({bottom: list_item});
    console.log(list_item);
  });
};

jQuery(document).ready(function() {
  jQuery.getScript($$(".flickr").first().readAttribute("data-url"));
});
