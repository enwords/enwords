$(document).on('turbolinks:load', function () {
  'use strict';

  var $previousPage = $('.previous_page');
  var $nextPage     = $('.next_page');
  var $linkResult   = $('#link-result');

  $previousPage.on('click', onclickRedirect);
  $nextPage.on('click', onclickRedirect);
  $linkResult.on('click', onclickRedirect);

  function onclickRedirect() {
    if ($(this).attr('href') !== undefined) {
      window.location = $(this).attr('href');
    }
  }

  $(document).keyup(function (e) {
    switch (e.which) {
      case 37:
        $previousPage.trigger('click');
        break;
      case 39:
        $linkResult.trigger('click');
        $nextPage.trigger('click');
        break;
    }
  });
});
