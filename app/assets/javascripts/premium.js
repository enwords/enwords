$(function() {
  'use strict';

  let $price = $('.premium.price');

  let togglePremiumPrice = (e) => {
    let $target = $(e.target);

    $price.removeClass('active')
    $target.addClass('active')
  }

  $price.on('click', togglePremiumPrice)
});
