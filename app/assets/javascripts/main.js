$(function () {
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
});
