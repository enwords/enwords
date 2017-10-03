$(function () {
  'use strict';

  var $selectedWord = $('.eng-rus .word-skyeng');

  $selectedWord.qtip({
    position: {
      my: 'bottom left',
      at: 'top right',
      viewport: true,
    },
    show: {
      event: 'click',
    },
    hide:     {
      event: 'unfocus',
      fixed: true,
      delay: 500,
    },
    style:    {
      classes: 'qtip-bootstrap',
    },
    content:  {
      text: function (event, api) {
        $.ajax({
          url:      '/first_meaning',
          data:     { word: $(this).text() },
          type:     'GET',
          dataType: 'json',
        })
          .done(function (data) {
            var word          = data.text;
            var translation   = data.translation.text.capitalize();
            var transcription = data.transcription;
            var previewUrl    = data.previewUrl;
            var soundUrl      = data.soundUrl;

            var content = (
            '<div style="font-size: 1.25rem; font-weight: 100">' +
            '<span> ' +
              '<span class="fa fa-volume-up" onclick="$(this).children(\'audio\')[0].play();" style="cursor: pointer">' +
                '<audio src="' + soundUrl + '"></audio>' +
              '</span>' +
              '<span> ' + word.capitalize() + '</span>' +
            '</span>' +
              '<span style="color: #b9b9b9"> [' + transcription + ']</span>' +
              '<span> ' + translation + '</span>' +
            '</div>');

            api.set('content.text', content);
          })
          .fail(function (xhr, status, error) {
            api.set('content.text', status + ': ' + error);
          });

        return '  <i class="fa fa-spinner fa-spin"></i>';
      },
    },
  });
});
