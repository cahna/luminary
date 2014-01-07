
$(document).ready(function(){
  $('#luminary-button').click(function(){
    $('#luminary').removeClass('hide');
  });
  $('.luminary-close').click(function(){
    $('#luminary').addClass('hide');
  });
  _editor = new Lapis.Editor('#editor');
});

