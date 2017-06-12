$(function () {
  'use strict';

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
