$(document).on('turbolinks:load', function () {
  'use strict';

  var $originalSentence = $('#original-sentence');
  var $nextPage         = $('.next_page');
  var $inputSentence    = $('.input-sentence');

  $nextPage.on('click', function () {
    if (replacePunctuation($inputSentence.val()) === replacePunctuation($originalSentence.text())) {
      $inputSentence.addClass('input-sentence_right');
      setTimeout(function () {
        $inputSentence.removeClass('input-sentence_right');
        window.location = $nextPage.attr('href');
      }, 800);

      return false;
    } else {
      $inputSentence.addClass('input-sentence_wrong');
      setTimeout(function () {
        $inputSentence.removeClass('input-sentence_wrong');
      }, 800);

      return false;
    }
  });

  function replacePunctuation(str) {
    return str.toLowerCase().replace(/[.,\/#!$%\^&\*;:{}=\-_`~()\s]/g, '');
  }

  $inputSentence.keypress(function (e) {
    if (e.keyCode === 13) {
      e.preventDefault();
      $nextPage.trigger('click');
    }
  });
});
