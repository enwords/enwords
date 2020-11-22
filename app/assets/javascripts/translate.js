$(function() {
  'use strict';

  String.prototype.capitalize = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
  };

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
              var script;
              var transcriptionBlock;
              if(data.translation != null) {
                translation = data.translation.capitalize();
                transcription = data.transcription;
                soundUrl = data.sound_url;
                if(soundUrl != null) {
                  icon = 'fa fa-volume-up'
                  audio = '<audio src="' + soundUrl + '"></audio>'
                  script = ''
                } else {
                  icon = 'fa fa-volume-up'
                  audio = ''
                  script = 'onclick="tts(\'' + data.text.replaceAll("'", '`') + '\', \'' + data.from + '\')"'
                }
                transcriptionBlock = ' - ';
                if(typeof transcription !== 'undefined' && transcription !== null) {
                  transcriptionBlock = '[' + transcription + ']';
                }
                content = content + (
                  '<span class="word-translate-icon"> ' +
                  '<span ' + script + ' class="' + icon + '" onclick="$(this).children(\'audio\')[0].play();">' +
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
                  '<div class="yg-wrap">' +
                  '<a id="yg-widget-0" class="youglish-widget" data-query="' + word + '" data-lang="' + youglish.lang + '" data-accent="' + youglish.accent + '" data-components="64" height="233" data-video-quality="small" data-auto-start="0" rel="nofollow" href="https://youglish.com" data-bkg-color="#272727" data-bkg-color="theme_dark" data-link-color="#808080" data-ttl-color="#E2E2E2" data-cap-color="#E2E2E2" data-marker-color="#EB3324" data-panels-bkg-color="#272727" data-text-color="#E2E2E2" data-keyword-color="#E2E2E2"></a>' +
                  '<script async src="https://youglish.com/public/emb/widget.js" charset="utf-8"></script>' +
                  '</div>'
              }
              api.set('content.text', content);
              setTimeout(function() {
                $("#fr_yg-widget-0").css('margin', '0')
                $('.yg-wrap').slideDown()
              }, 2000);
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
