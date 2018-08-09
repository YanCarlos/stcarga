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
      $('#other-user-form').find('input').val('');
      $('#other-user-form').find('input').removeAttr('required');
      $('#other-user-form').find('input').prop('disabled',true);
      $('#customer-form').find('input').prop('required', true);
      $('#customer-form').find('input').removeAttr('disabled');
      $('#other-user-form').hide();
      $('#customer-form').show();
    }else{
      $('#customer-form').find('input').val('');
      $('#customer-form').find('input').removeAttr('required');
      $('#customer-form').find('input').prop('disabled',true);
      $('#other-user-form').find('input').prop('required', true);
      $('#other-user-form').find('input').removeAttr('disabled');
      $('#customer-form').hide();
      $('#other-user-form').show();
    }
  }

  validate_customer_select();

  $('#customer_select').change(function() {
    validate_customer_select();
  });

  $('#dispatch_product_import_product_id').change(function(){
    $.ajax({
      url: '/get_products_in_stock/' + $(this).val(),
      context: document.body
    }).done(function(result) {
      $("#available_packages_for_dispatch").val(result);
      $("#dispatch_product_total_of_packages").attr({
         "max" : result,
         "min" : 0    
      });
    });
  });

  $('#dispatch_product').change(function(){
    $.ajax({
      url: '/get_products_in_stock/' + $(this).val(),
      context: document.body
    }).done(function(result) {
      $("#available_packages_for_dispatch").val(result);
      $("#dispatch_product_total_of_packages").attr({
         "min" : 0    
      });
    });
  });

  $('.selectize').selectize({
    sortField: 'text'
  });


};

$(document).on('turbolinks:load', ready)
