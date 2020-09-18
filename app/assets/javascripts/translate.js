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
        classes: 'qtip-bootstrap translate-tab',
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
              var content = '';
              var word = data.text.capitalize();
              var translation;
              var transcription;
              var soundUrl;
              var icon;
              var audio;
              var transcriptionBlock;
              if(data.translation != null) {
                translation = data.translation.capitalize();
                transcription = data.transcription;
                soundUrl = data.sound_url;
                if(soundUrl != null) {
                  icon = 'fa fa-volume-up'
                  audio = '<audio src="' + soundUrl + '"></audio>'
                } else {
                  icon = 'fa fa-volume-off'
                  audio = ''
                }
                transcriptionBlock = ' - ';
                if(typeof transcription !== 'undefined' && transcription !== null) {
                  transcriptionBlock = '[' + transcription + ']';
                }
                content = content + (
                  '<span class="word-translate-icon"> ' +
                  '<span class="' + icon + '" onclick="$(this).children(\'audio\')[0].play();">' +
                  audio +
                  '</span>' +
                  '<span> ' + word + '</span>' +
                  '</span>' +
                  '<span> ' + transcriptionBlock + '</span>' +
                  '<span> ' + translation + '</span>'
                );
              }
              var youglish = data.youglish
              if(youglish != null) {
                content = content +
                  '<br>' +
                  '<div class="yg-wrap" style="display: none"><a id="yg-widget-0" class="youglish-widget" data-query="' + word + '" data-lang="' + youglish.lang + '" data-accent="' + youglish.accent + '" data-components="220" data-auto-start="0" data-link-color="#808080" data-ttl-color="#5A98D0" data-cap-color="#5A98D0" data-marker-color="#FFF700" data-panels-bkg-color="#FF0000" data-text-color="#5A98D0" data-keyword-color="#5A98D0" data-video-quality="medium" data-title="Example %i% from %total%:" rel="nofollow" href="https://youglish.com"/a></div>' +
                  '<script async src="https://youglish.com/public/emb/widget.js" charset="utf-8"></script>'
              }
              api.set('content.text', content);
              setTimeout(function() {
                $('.yg-wrap').slideDown()
              }, 1000);
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
