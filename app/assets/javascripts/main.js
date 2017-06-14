$(document).on('turbolinks:load', function () {
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
  $('.alert-success, .alert-notice').fadeOut(3000);

  // bugfix dropdown
  $('.dropdown-toggle').dropdown();

  window.onerror = function (e) {
    if (e.match(/Collapse is transitioning/gi) ||
      e.match(/dropdown is not a function/gi)  ||
      e.match(/has already been loaded/gi)) {
      location.reload();
    }
  };

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

  // skyeng
  var $selectedWord = $('.eng-rus .word-skyeng');

  $selectedWord.qtip({
    position: {
      my: 'center left',  // Position my top left...
      at: 'center right', // at the bottom right of...
    },
    hide:     {
      fixed: true,
      delay: 500,
    },
    style:    {
      classes: 'qtip-bootstrap',
    },
    content:  {
      text: function (event, api) {
        $.ajax({
          url:      '//dictionary.skyeng.ru/api/public/v1/words/search?search=' + $(this).text(),
          type:     'GET',
          dataType: 'json',
        })
          .done(function (data) {

            data = data.sort(function (a, b) {
              return parseFloat(a.id) - parseFloat(b.id);
            });

            var word          = data[0].text;
            var translation   = data[0].meanings[0].translation.text.capitalize();
            var transcription = data[0].meanings[0].transcription;
            var previewUrl    = data[0].meanings[0].previewUrl;
            var soundUrl      = data[0].meanings[0].soundUrl;

            var content = (
            '<div style="font-size: 1.25rem; font-weight: 100">' +
            '<span class="fa fa-volume-up" onclick="$(this).children(\'audio\')[0].play();" style="cursor: pointer">' +
            '<audio src="' + soundUrl + '"></audio>' +
            '</span>' +
            '<span style="color: #b9b9b9"> [' + transcription + ']</span>' +
            '<span> ' + translation + '</span>' +
            '</div>');

            api.set('content.text', content);
          })
          .fail(function (xhr, status, error) {
            api.set('content.text', status + ': ' + error);
          });

        return 'Loading...';
      },
    },
  });

});
