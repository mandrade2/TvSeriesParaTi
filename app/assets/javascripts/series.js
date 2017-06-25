$(document).on('turbolinks:load', function () {
  var $spoiler_anchors = $('button.spoiler_button');
  $spoiler_anchors.on('click', function (){
    var $button;
    var $comment;
    $button = $(this);
    console.log($button.attr('data-toggle'));
    $comment = $("#" + $button.attr('data-toggle'));
    console.log($comment.text());
    $comment.removeClass('spoiler');
    $button.hide();
  });
});
