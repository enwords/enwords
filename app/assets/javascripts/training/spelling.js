$(function () {
  'use strict';

  var $nextPage     = $('.next_page');
  var $inputWord    = $('.input-word');
  var $originalWord = $inputWord.data('hidden-word');

  $nextPage.on('click', function () {
    if (replacePunctuation($inputWord.val()) === replacePunctuation($originalWord)) {
      $inputWord.addClass('input-word_right');
      setTimeout(function () {
        $inputWord.removeClass('input-word_right');
        window.location = $nextPage.attr('href');
      }, 800);

      return false;
    } else {
      $inputWord.addClass('input-word_wrong');
      setTimeout(function () {
        $inputWord.removeClass('input-word_wrong').val('').attr('placeholder' , $originalWord);
      }, 800);

      return false;
    }
  });

  function replacePunctuation(str) {
    return str.toLowerCase().replace(/[.,\/#!$%\^&\*;:{}=\-_`~()\s]/g, '');
  }

  $inputWord.keypress(function (e) {
    if (e.keyCode === 13) {
      e.preventDefault();
      $nextPage.trigger('click');
    }
  });
});
