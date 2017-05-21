$(function () {
  'use strict';

  //checkboxes
  var $selectAll = $('#select-all');

  $selectAll.on('click', function() {
    var $checkboxes = $(':input[name^=ids]');

    for (var i = 0, n = $checkboxes.length; i < n; i++) {
      $checkboxes[i].checked = this.checked;
    }
  });

  // flash
  $('.alert-success, .alert-notice').fadeOut(3000);

  // bugfix dropdown
  $('.dropdown-toggle').dropdown();
});
