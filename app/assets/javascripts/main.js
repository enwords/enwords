$(function () {
  'use strict';

  // flash
  $('.alert').delay(1000).fadeOut(4000);

  // other
  String.prototype.capitalize = function () {
    return this.charAt(0).toUpperCase() + this.slice(1);
  };

  $('.words-from-sentence-after').hide().fadeIn(500);

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
