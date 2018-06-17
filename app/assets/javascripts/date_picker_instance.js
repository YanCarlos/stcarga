$(document).on('turbolinks:load', function(){
  $.fn.datepicker.defaults.format = "dd/mm/yyyy";
  $.fn.datepicker.defaults.startDate= '-3d';
});
