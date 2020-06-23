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
    events: {
      hidden: function(event, api) {
        api.destroy(true);
      }
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

            var transcriptionBlock = ' - ';
            if (typeof transcription !== 'undefined') {
              transcriptionBlock = '[' + transcription + ']';
            }

            var content = (
              '<div style="font-size: 1.25rem; font-weight: 100">' +
              '<span> ' +
              '<span class="fa fa-volume-up" onclick="$(this).children(\'audio\')[0].play();" style="cursor: pointer">' +
              '<audio src="' + soundUrl + '"></audio>' +
              '</span>' +
              '<span> ' + word.capitalize() + '</span>' +
              '</span>' +
              '<span style="color: #b9b9b9"> ' + transcriptionBlock + '</span>' +
              '<span> ' + translation + '</span>' +
              '<br>' +
              '<a id="yg-widget-0" class="youglish-widget" data-query="' + word + '" data-lang="english" data-lang="english" data-components="220" data-auto-start="0" data-link-color="#808080" data-ttl-color="#5A98D0" data-cap-color="#5A98D0" data-marker-color="#FFF700" data-panels-bkg-color="#FF0000" data-text-color="#5A98D0" data-keyword-color="#5A98D0" data-video-quality="medium" data-title="%D0%9F%D1%80%D0%B8%D0%BC%D0%B5%D1%80%20%25i%25%20%D0%B8%D0%B7%20%25total%25%3A"  rel="nofollow" href="https://youglish.com">Visit YouGlish.com</a>\n' +
              '<script async src="https://youglish.com/public/emb/widget.js" charset="utf-8"></script>' +
              '</div>');

            api.set('content.text', content);
          })
          .fail(function (xhr, status, error) {
            api.set('');
          });

        return '<i class="fa fa-spinner fa-spin"></i>';
      },
    },
  });
});
