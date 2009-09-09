jQuery.noConflict();

// var addComment = function(list, data) {
var generateComment = function(grumble) {
  var comment = jQuery(document.createElement('li')).addClass('comment').addClass('clear');
  comment.append( jQuery(document.createElement('div')).
    addClass("grumbler").text(grumble["grumbler_name"]) );
  comment.append( jQuery(document.createElement('div')).
    addClass("body").text(grumble["body"]) );
  // created_at
  return comment;
}

var targetFetched = function(grumbling) {
  jQuery('#grumble .count').text(grumbling.target.grumble_count + ' Grumbles');
}

var grumblesFetched = function(grumbling) {
  grumbling.grumbles.each(function(grumble) {
    jQuery('#grumble ul').prepend(generateComment(grumble));
  });
}

var grumbleCreated = function(grumbling) {
  jQuery('#grumble ul').append(generateComment(grumbling.grumble));
  grumbleClient.fetchTarget();
}

var grumbleClient = new Grumble.Client(document.location.href, {
  callbacks: {
    grumbleCreated: grumbleCreated, targetFetched: targetFetched, grumblesFetched: grumblesFetched
  }
});

jQuery(document).ready(function() {
  grumbleClient.fetchTarget();
  grumbleClient.fetchGrumbles();
  
  jQuery('#new_comment').submit(function(event) {
    grumbleClient.postGrumble(this.serialize(true));
    event.stopPropagation();
    return false;
  });
});
