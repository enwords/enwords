// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .

//checkboxes
function toggle(source) {
    checkboxes = document.getElementsByName('words_ids[]');
    for(var i=0, n=checkboxes.length;i<n;i++) {
        checkboxes[i].checked = source.checked;
    }
}

//audio
function play() {
    var audio = document.getElementById("audio-play");
    audio.play();
}

function setColor(grey, orange, green, n, left_edge, right_edge) {
    var property_switch = document.getElementsByClassName("slider")[n];
    var property_button = document.getElementsByClassName("button_hide")[n];
    var property_slider = document.getElementsByClassName("round")[n];

    if (property_switch.style.backgroundColor == grey || property_switch.style.backgroundColor == orange) {
        property_switch.style.backgroundColor = green;
        property_button.action = property_button.action.replace("false", "true");
        property_slider.style.left = right_edge
    }

    else if (property_switch.style.backgroundColor == green) {
        property_switch.style.backgroundColor = orange;
        property_button.action = property_button.action.replace("true", "false");
        property_slider.style.left = left_edge

    }
}
