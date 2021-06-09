$(function () {
  'use strict';

  $('.words-from-sentence-after').hide().fadeIn(500);

  var $btnShowTranslation = $('.translation-block a');

  $btnShowTranslation.on('click', function (e) {
    e.preventDefault();
    $(this).fadeOut(0);
    $('.translation-block .hidden').fadeIn(750);
  });

  $('.btn-play-audio').on('click', function() {
    var audio = $(this).children('audio')[0]
    if(audio !== null && audio !== undefined) audio.play();
  });

  $(document).keyup(function (e) {
    switch (e.which) {
      case 40:
        $btnShowTranslation.trigger('click');
        break;
      case 38:
        $('.btn-play-audio').trigger('click');
        break;
    }
  });
});
