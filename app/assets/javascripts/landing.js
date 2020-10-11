//= require jquery
//= require jquery_ujs
//= require mdb
//= require facebook
//= require me-talk
//= require locale_switcher
//= require premium

$(function() {
  'use strict';

  $(window).scroll(function() {
    var x = $(this).scrollTop();
    $('.landing .planets').css('background-position', parseInt(x * 0.5) + 'px ' + parseInt(x * 2.0) + 'px');
    $('.landing .moon').css('background-position', parseInt(-x * 1.0) + 'px ' + parseInt(-x * 1.0) + 'px');
    $('.landing .rocket').css('background-position', parseInt(x * 2.0) + 'px ' + parseInt(x * 1.5) + 'px');
  });
});
