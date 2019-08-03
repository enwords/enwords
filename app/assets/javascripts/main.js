$(function () {
  'use strict';

  //checkboxes
  var $checkAll        = $('#check-all');
  var $check           = $('.check');
  var triggeredByChild = false;

  $('input').iCheck({
    checkboxClass: 'icheckbox_minimal-orange',
  });

  $checkAll.on('ifChecked', function () {
    $check.iCheck('check');
    triggeredByChild = false;
  });

  $checkAll.on('ifUnchecked', function () {
    if (!triggeredByChild) {
      $check.iCheck('uncheck');
    }

    triggeredByChild = false;
  });

  $check.on('ifUnchecked', function () {
    triggeredByChild = true;
    $checkAll.iCheck('uncheck');
  });

  $check.on('ifChecked', function () {
    if ($check.filter(':checked').length === $check.length) {
      $checkAll.iCheck('check');
    }
  });

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

  $('[name="generate_phrase_form"]').on('ajax:success', function(event, data, status, xhr) {
    var funny_phrase = "Today you're like a " + data.resource;
    $('[name="generate_phrase_result_field"]').val(funny_phrase)
  });
});
