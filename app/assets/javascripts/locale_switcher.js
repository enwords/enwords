$(function () {
  'use strict';

  $('#locale_switcher').on('change', function() {
    window.location.replace($(location).attr('protocol') + '//' + $(location).attr('host') + '/' + $('#locale_switcher').val())
  })
});
