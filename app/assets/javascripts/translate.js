$(function() {
  'use strict';

  var $selectedWord = $('.word-translate');

  function initQtip() {
    $selectedWord.qtip({
      position: {
        my: 'bottom left',
        at: 'top right',
        viewport: true,
      },
      show: {
        event: 'click',
      },
      hide: {
        event: 'unfocus',
        fixed: true,
        delay: 500,
      },
      events: {
        hidden: function(event, api) {
          api.destroy(true);
          initQtip();
        }
      },
      style: {
        classes: 'qtip-bootstrap',
      },
      content: {
        text: function(event, api) {
          $.ajax({
            url: '/api/web/translations',
            data: {
              word: $(this).text(),
              from: $(this).data('from'),
              to: $(this).data('to')
            },
            type: 'GET',
            dataType: 'json',
          })
            .done(function(data) {
              var word = data.text;
              var translation = data.translation.text.capitalize();
              var transcription = data.transcription;
              var previewUrl = data.previewUrl;
              var soundUrl = data.soundUrl;
              if (soundUrl != null) {
                var icon = 'fa fa-volume-up'
                var audio = '<audio src="' + soundUrl + '"></audio>'
              } else {
                var icon = 'fa fa-volume-off'
                var audio = ''
              }
              var youglish = data.youglish
              var transcriptionBlock = ' - ';
              if(transcription !== 'undefined' && transcription !== null) {
                transcriptionBlock = '[' + transcription + ']';
              }
              if(youglish != null) {
                var youglishContent =
                  '<br>' +
                  '<a id="yg-widget-0" class="youglish-widget" data-query="' + word + '" data-lang="' + youglish.lang + '" data-accent="' + youglish.accent + '" data-components="220" data-auto-start="0" data-link-color="#808080" data-ttl-color="#5A98D0" data-cap-color="#5A98D0" data-marker-color="#FFF700" data-panels-bkg-color="#FF0000" data-text-color="#5A98D0" data-keyword-color="#5A98D0" data-video-quality="medium" data-title="Example %i% from %total%:" rel="nofollow" href="https://youglish.com"/a>' +
                  '<script async src="https://youglish.com/public/emb/widget.js" charset="utf-8"></script>'
              } else {
                var youglishContent = ''
              }

              var content = (
                '<div style="font-size: 1.25rem; font-weight: 100">' +
                '<span class="word-translate-icon"> ' +
                '<span class="' + icon + '" onclick="$(this).children(\'audio\')[0].play();">' +
                audio +
                '</span>' +
                '<span> ' + word.capitalize() + '</span>' +
                '</span>' +
                '<span style="color: #b9b9b9"> ' + transcriptionBlock + '</span>' +
                '<span> ' + translation + '</span>' +
                youglishContent +
                '</div>');

              api.set('content.text', content);
            })
            .fail(function(xhr, status, error) {
              api.set('');
            });

          return '<i class="fa fa-spinner fa-spin"></i>';
        },
      },
    });
  }

  initQtip()
});
