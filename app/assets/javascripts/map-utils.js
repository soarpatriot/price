
var styleOptions = {
  
    strokeColor:"green",    //边线颜色。
    fillColor:"green",      //填充颜色。当参数为空时，圆形将没有填充效果。
    strokeWeight: 3,       //边线的宽度，以像素为单位。
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

var editPloygon = function(e,ee,ploygon){
  ploygon.enableEditing()
};
var savePloygon = function(e,ee,ploygon){
    var points = ploygon.getPath();
    var pos = convertObjToDataPoints(points);

    var stationId = ploygon.stationId;
    var data = {id:stationId,points:pos}
    var dataStr= JSON.stringify(data);
    console.log("data:" + JSON.stringify(data));
    $.ajax({
      type:"put",
      dataType: "json",
      contentType: "application/json",
      url: "http://localhost:9000/v1/stations/"+stationId+".json", 
      headers: {"X-HTTP-Method-Override": "put"}, 
      success: function(station){
        ploygon.stationId = station.id; 
      },
      data: dataStr
    }); 
    ploygon.disableEditing();

};
var deletePloygon = function(e,ee,ploygon){

    var stationId = ploygon.stationId;
    var data = {id:stationId}
    var dataStr= JSON.stringify(data);
    console.log("data:" + JSON.stringify(data));
    if(stationId){
      var data = {id:stationId}
      var dataStr= JSON.stringify(data);
      $.ajax({
        type:"delete",
        dataType: "json",
        contentType: "application/json",
        url: "http://localhost:9000/v1/stations/"+stationId+".json", 
        headers: {"X-HTTP-Method-Override": "delete"}, 
        data: dataStr
      }); 
    }
    var map = ploygon.getMap();
    map.removeOverlay(ploygon);

}
var saveAreaPloygon = function(e,ee,ploygon){
    var points = ploygon.getPath();
    var pos = convertObjToDataPoints(points);

    var stationId = ploygon.stationId;
    var data = {id:stationId,points:pos}
    var dataStr= JSON.stringify(data);
    console.log("data:" + JSON.stringify(data));
    $.ajax({
      type:"put",
      dataType: "json",
      contentType: "application/json",
      url: "http://localhost:9000/v1/stations/"+stationId+".json", 
      headers: {"X-HTTP-Method-Override": "put"}, 
      data: dataStr
    }); 
    ploygon.disableEditing();

};

function deletePloygonArea(e,ee,ploygon){
  var areaId = ploygon.areaId; 
  if(areaId){
    var dataStr = '{"id":'+areaId+'}'
    $.ajax({
      type:"delete",
      dataType: "json",
      contentType: "application/json",
      url: "http://localhost:9000/v1/areas/"+areaId+".json", 
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


