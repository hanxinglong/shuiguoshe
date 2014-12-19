// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require jquery.countdown.min
//= require turbolinks
//= require jquery.chosen
//= require_tree .

$(function(){
    $(window).scroll(function(){
    var top=$(window).scrollTop();
    if( top>200 ){
      $("#scrolltop").fadeIn();
    } else {
      $("#scrolltop").fadeOut();
    }
});
 
$("#scrolltop").click(function(){
    $("html,body").animate({scrollTop:0});
    });
});

$(document).ready(function() {
  $("select").chosen({"search_contains": true, "no_results_text":"没有找到", "placeholder_text_single":"请选择小区"});
});
