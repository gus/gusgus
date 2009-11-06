function jsonFlickrFeed(data) {
  var list = $(".flickr");
  $(data.items).each(function(i) {
    var item = this;
    var image_url = item.media.m.replace(/_m\.jpg$/, "_s.jpg");
    var image = $("<img>").attr({src: image_url, alt: item.title, title: item.title});
    var link = $("<a>").attr({href: item.link}).append(image);
    var list_item = $("<li>").append(link);
    list.append(list_item);
  });
};

$(document).ready(function() {
  $.getScript($(".flickr").attr("data-url"));
});
