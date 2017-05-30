$(function () {
  'use strict';

  var $btnShowTranslation = $('#btn-show-translation');

  $.ajax({
    url: '/words_from_sentence/' + $('#original-sentence').data('sentence-id'),
  }).done(function (data) {
    $('.words-from-sentence-before').replaceWith(data);
  });

  $btnShowTranslation.on('click', function () {
    $(this).fadeOut(0);
    $('#translation').fadeIn(750);
  });

  $('#btn-play-audio').on('click', function () {
    $(this).children('audio')[0].play();
  });

  $(document).keyup(function (e) {
    switch (e.which) {
      case 40:
        $btnShowTranslation.trigger('click');
        break;
      case 38:
        $('#btn-play-audio').trigger('click');
        break;
    }
  });
});
