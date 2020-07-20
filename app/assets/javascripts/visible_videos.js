//= require jquery.visible.min

function playVideo() {
  $('video').each(function() {
    if($(this).visible(true)) {
      $(this)[0].play();
    } else {
      $(this)[0].pause();
    }
  })
}

$(document).ready(playVideo);
$(window).scroll(playVideo);
