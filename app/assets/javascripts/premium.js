$(function() {
  'use strict';

  var $price = $('.premium.price');
  var $planSelect = $('#plan');

  function togglePremiumPrice(e) {
    var $target = $(e.target);

    $price.removeClass('active')
    $target.addClass('active')
    $planSelect.val($target.data('plan'))
  }

  $price.on('click', togglePremiumPrice)

  $(window).on('load', function() {
    $('#is_subscriber').modal('show');
  });
});
