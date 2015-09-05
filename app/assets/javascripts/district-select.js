
$(function(){
  if( $("#district-select-form").length > 0){
    $("#city_province_id").change(function(){
      $("#district-select-form").submit();
    })
  }
});
