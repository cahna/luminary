
var _editor;

$(document).ready(function(){
  /* Open Luminary */
  $('#luminary-button').click(function(){
    $('#luminary').removeClass('hide');
  });

  /* Close Luminary */
  $('.luminary-close').click(function(){
    $('#luminary').addClass('hide');
  });

});

