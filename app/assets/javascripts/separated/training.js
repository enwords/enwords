$(document).on('turbolinks:load', function () {
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
      $.ajax({
        url: '/change_status/' + $(this).data('id') + '/' + $(this).attr('data-status'),
      }).done(function (responce) {
        var $thisButton = $('[data-id=' + responce[0].word_id + ']');
        $thisButton.attr('data-status', responce[0].learned);
        $thisButton.removeClass('switcher_unknown').toggleClass('switcher_learned');
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
