$(function() {
  'use strict';

  var $price = $('.premium.price');

  function togglePremiumPrice(e) {
    var $target = $(e.target);

    $price.removeClass('active')
    $target.addClass('active')
  }

  $price.on('click', togglePremiumPrice)
});
