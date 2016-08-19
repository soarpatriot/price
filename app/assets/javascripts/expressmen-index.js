

$(function(){

  if($("#expressmen-index").length > 0) {
    $("#file-label").on("change","#expressmen",function(){
      $("#file-read-only").val($(this).val());   
    })
  }
})
