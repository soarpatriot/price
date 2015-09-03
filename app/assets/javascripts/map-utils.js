
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


