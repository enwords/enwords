$(function () {
  'use strict';

  var $originalSentence = $('#original-sentence').data('sentence-value');
  var $inputSentence    = $('.input-sentence');
  var $nextPage         = $('.next_page');

  $nextPage.on('click', process);
  $('#check-text-area').on('keyup', function(e) {if((e.keyCode || e.which) == 13) {process()}});

  function process() {
    if (replacePunctuation($inputSentence.val()) === replacePunctuation($originalSentence)) {
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
  }

  function replacePunctuation(str) {
    var result  = str.toLowerCase();
    var punctRE = /[\u2000-\u206F\u2E00-\u2E7F\\'!"#$%&()*+,\-.\/:;<=>?@\[\]^_`{|}~]/g;
    var spaceRE = /\s+/g;
    return result.replace(punctRE, '').replace(spaceRE, '');
  }

  $inputSentence.keypress(function (e) {
    if (e.keyCode === 13) {
      e.preventDefault();
      $nextPage.trigger('click');
    }
  });
});
