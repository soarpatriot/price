
$(function(){
  if( $("#stations-delivery").length > 0){
    $("#province_id").select2({ width: '100px' ,language:"zh-CN" ,theme:"bootstrap"}); 
    $("#city_id").select2({ width: '100px' , language:"zh-CN",theme:"bootstrap" }); 



    $("#province_id").change(function(){
      $("#station-delivery-form").submit();
    });
    var provinceId =  $("#province_id").val();
    //console.log("province:"+provinceId);
    if(provinceId){

      var cityUrl = api.baseUrl + "/provinces/" + provinceId + "/cities.json?api_key=" + api.appKey
      var cityOption = "";
      var citySelected = $("#city_selected").val();
      $.get(cityUrl,{id:provinceId},function(cities){
         console.log("cities:"+ cities);
         cityOption += '<option value=""></option>'; 
         $.each(cities,function(index,city){
           cityOption += '<option value="'+city.id+'">'+city.description+'</option>'; 
         });
         $("#city_id").empty();
         $("#city_id").append(cityOption);
         if(citySelected){
           $("#city_id").val(citySelected);
         }
      });
      $("#city_id").change(function(){
        $("#station-delivery-form").submit();
      });
    }
  }
});
