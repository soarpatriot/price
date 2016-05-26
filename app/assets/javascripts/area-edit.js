

$(function(){
  if($("#areas-edit").length > 0) {

    $("#area_expressman_ids").select2({allowClear: true});
    $("#update-expressmen").click(function(){
      $(this).text("更新中,请稍等...");
      $(this).addClass("disabled")
    })
  }    
});
 
