$(document).on('turbolinks:load', function(){
  $.fn.datepicker.defaults.format = "dd/mm/yyyy";
  $.fn.datepicker.defaults.startDate= '-3d';
  $.fn.datepicker.defaults.changeMonth: true;
  $.fn.datepicker.defaultschangeYear: true;
});
