$(document).on('has_many_add:after', function(event) {
  $('.select.input select').chosen({
    allow_single_deselect: true,
    width: '30%'
  })
});
