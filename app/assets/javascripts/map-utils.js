
var api = api || {}
api.baseUrl = "http://localhost:9000/v1";

var styleOptions = {
  
    strokeColor:"#EE1010",    //边线颜色。
    fillColor:"green",      //填充颜色。当参数为空时，圆形将没有填充效果。
    strokeWeight: 1,       //边线的宽度，以像素为单位。
    strokeOpacity: 0.8,    //边线透明度，取值范围0 - 1。
    fillOpacity: 0.6,      //填充的透明度，取值范围0 - 1。
    enableEditing: false,
    strokeStyle: 'solid' //边线的样式，solid或dashed。
}
var drawOptions = {
    strokeColor:"red",    //边线颜色。
    fillColor:"red",      //填充颜色。当参数为空时，圆形将没有填充效果。
    strokeWeight: 3,       //边线的宽度，以像素为单位。
    strokeOpacity: 0.8,    //边线透明度，取值范围0 - 1。
    fillOpacity: 0.6,      //填充的透明度，取值范围0 - 1。
    enableEditing: false,
    strokeStyle: 'solid' //边线的样式，solid或dashed。
}
var randomFillOptions = function(){
  var i=0;
  var colors = ["#2238DF","#22DF4B","#F3EF0F","#F30FEF","#0FF3E4","#845F0F","#490F84","#4F6A4E"];
  var random = function(){
    if(i >= colors.length) {
      i = 0;
    }
    var drawOptions = {
      strokeColor:"red",    //边线颜色。
      fillColor:colors[i],      //填充颜色。当参数为空时，圆形将没有填充效果。
      strokeWeight: 2,       //边线的宽度，以像素为单位。
      strokeOpacity: 0.8,    //边线透明度，取值范围0 - 1。
      fillOpacity: 0.6,      //填充的透明度，取值范围0 - 1。
      enableEditing: false,
      strokeStyle: 'solid' //边线的样式，solid或dashed。
    }
    i++;
    return drawOptions;
  }
  return random; 
}
var editPloygon = function(e,ee,ploygon){
  ploygon.enableEditing()
};

var deletePloygon = function(e,ee,ploygon){

    var stationId = ploygon.stationId;
    var data = {id:stationId}
    var dataStr= JSON.stringify(data);
    console.log("data:" + JSON.stringify(data));
    var deleteUrl = api.baseUrl + "/stations/" + stationId + ".json";
    if(stationId){
      var data = {id:stationId}
      var dataStr= JSON.stringify(data);
      $.ajax({
        type:"delete",
        dataType: "json",
        contentType: "application/json",
        url: deleteUrl, 
        headers: {"X-HTTP-Method-Override": "delete"}, 
        data: dataStr
      }); 
    }
    var map = ploygon.getMap();
    map.removeOverlay(ploygon);

}

function deletePloygonArea(e,ee,ploygon){
  var areaId = ploygon.areaId; 
  if(areaId){
    var deleteUrl = api.baseUrl + "/areas/" + areaId + ".json";
    var dataStr = '{"id":'+areaId+'}'
    $.ajax({
      type:"delete",
      dataType: "json",
      contentType: "application/json",
      url: deleteUrl, 
      headers: {"X-HTTP-Method-Override": "delete"}, 
      data: dataStr
    }); 
  }
  var map = ploygon.getMap();
  map.removeOverlay(ploygon);
};

function setPloygonArea(e,ee,ploygon) {
  var points = ploygon.getPath();
  var pos  =  convertObjToDataPoints(points)
  $("#ploygon-index").val(ploygon.index);
  $("#commission-modal").modal("show");
}


function setPloygonStation(e,ee,ploygon) {
  console.log("index:"+ploygon.index);
  var points = ploygon.getPath();
  var pos  =  convertObjToDataPoints(points)
  $("#ploygon-index").val(ploygon.index);
  $("#station-name").val(ploygon.stationName);
  $("#station-modal").modal("show");
}


function convertObjToDataPoints(points){

  //console.log("points:"+points);
  var pos = [];
  $.each(points,function(key,point){
    var p = {lantitude:point.lat,longitude:point.lng};
    pos.push(p);
  })
  return pos;
} 



function clearAll() {
    for(var i = 0; i < overlays.length; i++){
        map.removeOverlay(overlays[i]);
    }
    overlays.length = 0   
}

function convertToPointsOjeArray(ps){
  var pointsArr = []
  var p;
  for(i=0;i< ps.length ;i++){
    p = new BMap.Point(ps[i].longitude,ps[i].lantitude); 
    pointsArr.push(p); 
  }
  return pointsArr;
}
function poArr(ps){
  var pointsArr = []
  var p;
  for(i=0;i< ps.length ;i++){
    p = new BMap.Point(ps[i].lng,ps[i].lat); 
    pointsArr.push(p); 
  }
  return pointsArr
} 


