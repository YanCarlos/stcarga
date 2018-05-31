var ready =  function(){
  
  function validate_customer_select(){
    if($("#customer_select option:selected").val() == 'customer'){
      show_customer_form(true);
    }else{
      show_customer_form(false);
    }
  }

  function show_customer_form(flat){
    if(flat){
      $('#customer-form').find('input').prop('required', true);
      $('#customer-form').show();
    }else{
      $('#customer-form').find('input').val('');
      $('#customer-form').find('input').removeAttr('required');
      $('#customer-form').hide();
    }
  }

  validate_customer_select();

  $('#customer_select').change(function() {
    validate_customer_select();
  });
};

$(document).on('turbolinks:load', ready)
