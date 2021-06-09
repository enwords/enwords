$(function () {
  'use strict';

  $.ajax({
    url: '/words_from_sentence/' + $('#original-sentence').data('sentence-id'),
  }).done(function (html) {
    $('.words-from-sentence-before').replaceWith(html);
    $('.words-from-sentence-after').fadeIn(500);

    // switcher

    $('[data-status="true"]').addClass('word_status_switcher_learned');
    $('[data-status="unknown"]').addClass('word_status_switcher_unknown');

    $('.word_status_switcher').on('click', function () {
      var st = $(this).attr('data-status') === 'true';
      var new_st = !st;
      $(this).attr('data-status', new_st + '');
      $(this).removeClass('word_status_switcher_unknown').toggleClass('word_status_switcher_learned');
      $.ajax({
        url: '/change_status/' + $(this).data('id') + '/' + new_st
      });
    });
  });

  $.ajax({
    url: '/translation/' + $('#original-sentence').data('sentence-id'),
    type: 'GET',
    dataType: 'json'
  }).done(function (response) {
    $('.translation-block span').text(response.value)
  });
});
