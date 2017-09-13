$(function () {
  'use strict';

  var $btnShowTranslation = $('.translation-block a');

  $.ajax({
    url: '/words_from_sentence/' + $('#original-sentence').data('sentence-id'),
  }).done(function (html) {
    $('.words-from-sentence-before').replaceWith(html);
    $.getScript('/assets/skyeng.js');

    $('.words-from-sentence-after').fadeIn(500);

    // switcher
    var $switcher = $('.switcher');

    $('[data-status="true"]').addClass('switcher_learned');
    $('[data-status="unknown"]').addClass('switcher_unknown');

    $switcher.on('click', function () {
      var st = $(this).attr('data-status') === 'true';
      var new_st = !st;
      $(this).attr('data-status', new_st + '');
      $(this).removeClass('switcher_unknown').toggleClass('switcher_learned');
      $.ajax({
        url: '/change_status/' + $(this).data('id') + '/' + new_st
      });
    });
  });

  $btnShowTranslation.on('click', function (e) {
    e.preventDefault();
    $(this).fadeOut(0);
    $('.translation-block span').fadeIn(750);
  });

  $('.btn-play-audio').on('click', function () {
    $(this).children('audio')[0].play();
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
