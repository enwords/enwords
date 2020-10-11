//= require iCheck/icheck.min.js

$(function () {
  'use strict';

  //checkboxes
  var $checkAll        = $('#check-all');
  var $check           = $('.check');
  var triggeredByChild = false;

  $('input').iCheck({
    checkboxClass: 'icheckbox_minimal-pink',
  });

  $checkAll.on('ifChecked', function () {
    $check.iCheck('check');
    triggeredByChild = false;
    setCheckCount()
  });

  $checkAll.on('ifUnchecked', function () {
    if (!triggeredByChild) {
      $check.iCheck('uncheck');
    }

    triggeredByChild = false;
    setCheckCount()
  });

  $check.on('ifUnchecked', function () {
    triggeredByChild = true;
    $checkAll.iCheck('uncheck');
    setCheckCount()
  });

  $check.on('ifChecked', function () {
    if ($check.filter(':checked').length === $check.length) {
      $checkAll.iCheck('check');
    }
    setCheckCount()
  });

  function setCheckCount() {
    $('#check-count').text($('.check-word:checked').length);
  }
});
