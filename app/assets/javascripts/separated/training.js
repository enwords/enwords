$(function () {
  'use strict';

  $.ajax({
    url: '/words_from_sentence/' + $('#original-sentence').data('sentence-id'),
  }).done(function (data) {
    $('.words-from-sentence-before').replaceWith(data);
  });

  $('#btn-show-translation').on('click', function () {
    $(this).fadeOut(0);
    $('#translation').fadeIn(750);
  });

  $('#btn-play-audio').on('click', function () {
    $(this).children('audio')[0].play();
  });
});
