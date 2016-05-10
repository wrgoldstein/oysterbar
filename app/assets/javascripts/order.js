$(document).ready(function() {
  console.log('yo')
  console.log($('#activation_code').text().length)
  $('body').on('keyup', '#activation_code', function() {
    var empty = false;
    if ($('#activation_code').val() == '') {
      empty = true;
    }
    console.log("EMPTY", empty)
    if (empty) {
      $('#activation_code_submit').attr('disabled', 'disabled');
    } else {
      $('#activation_code_submit').removeAttr('disabled');
    }
  });
});
