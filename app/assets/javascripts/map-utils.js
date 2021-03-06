var api = api || {};
var utils = utils || {};
//api.baseUrl = "http://localhost:9000/v1";

$(function(){
  var apiBaseUrl = $("#api-base-url").val();
  var appKey = $("#app_key").val();
  api.baseUrl = apiBaseUrl;
  api.appKey = appKey; 

});
utils.concatDisply = function(label, code){
  if($.trim(code)){
    return label + "(" + code + ")";
  }else{
    return label; 
  }
}
utils.fullConcatDisply = function(label, code, price){
  var defaultValue = "无名称编号";
  var full = "";
  var flag = true; 
  if($.trim(label)){
    flag = false;
    full = full + "名称：" + label +"<br/>";
  }
  if($.trim(code)){
    flag = false;
    full = full + "编号：" + code +"<br/>";
  }
  if($.trim(price)){
    flag = false;
    full = full + "追加提成：" + price +"<br/>";
  }

  if(flag){
    return defaultValue;
  }
  return full;
}

utils.circleDrawOptions = {
  strokeColor: 'black',
  fillColor: 'green',
  fillOpacity: 0.01,
  strokeWeight: 1,
  strokeOpacity: 0.6,
  strokeStyle: 'solid',
  enableClicking: true
  
}
utils.computePolygonArea = function(polygon){
  var i,j,n,area;
  var EARTHRADIUS = 6370996.81; 
  area = 0;
  i = 0;
  points = polygon.getPath();
  n = points.length; 
  for(i=0; i<n; i++){
    j = (i+1) % n;  
    area += points[i].lat * points[j].lng;
    area -= points[i].lng * points[j].lat;
  }
  area = area / 2 * 110000 * 90000 / 1000000;
  return (area< 0? -area: area);
}

utils.addBoundary = function(map,district){
  var bdary = new BMap.Boundary();
  bdary.get(district, function(rs){       //获取行政区域
    var count = rs.boundaries.length; //行政区域的点有多少个
    if (count === 0) {
      return ;
    }
    var pointArray = [];
    for (var i = 0; i < count; i++) {
      var ply = new BMap.Polygon(rs.boundaries[i], utils.districtOptions); //建立多边形覆盖物
      map.districtPloys.push(ply);    //调整视野                 
      map.addOverlay(ply);  //添加覆盖物
      //pointArray = pointArray.concat(ply.getPath());
    }    
  });   
}

utils.ploygon = {
  areaMian: function(ploygon){
      var areaMian = BMapLib.GeoUtils.getPolygonArea(ploygon);
      if(_.isNaN(areaMian) || areaMian < 0 ){
        areaMian = utils.computePolygonArea(ploygon);
      }else{
        areaMian = areaMian/1000000;
      }
      return areaMian.toFixed(2);
  },
  distanceCenter: function(map,stationPoint, centerPoint){

      var distance = map.getDistance(stationPoint,centerPoint).toFixed(2);
      return distance;
  },
  addMenu: function(ploygon){
   
    var ployMenu = new BMap.ContextMenu();
    var editItem = new BMap.MenuItem('编辑',editPloygon.bind(ploygon));
    var saveItem = new BMap.MenuItem('保存',setPloygonArea.bind(ploygon));
    var deleteItem = new BMap.MenuItem('删除',deletePloygonArea.bind(ploygon));
    //var editAreaItem = new BMap.MenuItem('编辑所属站点',setPloygonArea.bind(ploygon));
    ployMenu.addItem(editItem);
    ployMenu.addItem(saveItem);
    ployMenu.addItem(deleteItem);
    ploygon.addContextMenu(ployMenu);

    return ploygon;
  },
  addDesc: function(map,ploygon,stationPoint){
    var centerPoint = ploygon.getBounds().getCenter();
    ploygon.areaMian = utils.ploygon.areaMian(ploygon);
    ploygon.areaMianDesc = ploygon.areaMian + "(平方公里)";
    ploygon.areaDistance = utils.ploygon.distanceCenter(map,stationPoint,centerPoint);
    return ploygon;
  },
  changeValue: function(map,ploygons,area,index){
    var areaMian = BMapLib.GeoUtils.getPolygonArea(ploygons[index]);
    var areaMianDesc = (areaMian/1000000).toFixed(2) + "(平方公里)";

    ploygons[index].areaId = area.id;
    ploygons[index].commissionId = area.commission_id;
    ploygons[index].commissionName = area.commission_name;
    ploygons[index].commissionPrice = area.commission_price;
    ploygons[index].areaLabel = area.label;
    ploygons[index].areaCode = area.code;
    ploygons[index].areaMianDesc = areaMianDesc;
    ploygons[index].areaDistance = area.distance;

    var centerPoint = ploygons[index].getBounds().getCenter();
    var opts = {position: centerPoint, offset: new BMap.Size(-15,-5)}
    var labelValue = utils.fullConcatDisply(area.label,area.code, area.commission_price);
    // var labelValue = utils.fullConcatDisply(area.commission_name,area.code, area.commission_price);
    var label = new BMap.Label(labelValue,opts);
    ploygons[index].centerLabel = label;
    map.addOverlay(label);

  },
  afterCreate: function(ploygons, area,index){
    var areaMian = BMapLib.GeoUtils.getPolygonArea(ploygons[index]);
    var areaMianDesc = (areaMian/1000000).toFixed(2) + "(平方公里)";


    // var areaMianDesc = areaMian.toFixed(2) + "平方米";
    var labelValue = utils.fullConcatDisply(area.label,area.code, area.commission_price);
    // var labelValue = utils.fullConcatDisply(area.commission_name,area.code, area.commission_price);
    ploygons[index].commissionId = area.commission_id;
    ploygons[index].commissionName = area.commission_name;
    ploygons[index].commissionPrice = area.commission_price;
    ploygons[index].areaLabel = area.label;
    ploygons[index].areaCode = area.code;
    ploygons[index].areaMianDesc = areaMianDesc;
    ploygons[index].areaDistance = area.distance;


    if(ploygons[index].centerLabel){
        ploygons[index].centerLabel.setContent(labelValue);
    }

  }
}

utils.addInfoWindowToPloygon = function(map, ploygon, htmlEle){
  var centerPoint = ploygon.getBounds().getCenter();
  ploygon.addEventListener('click',function(){
    _.templateSettings = {
      interpolate: /\{\{(.+?)\}\}/g
    };

    var areaTmp = _.template(htmlEle);
    var areaTmpWithValue = areaTmp({name:ploygon.areaLabel,
                                   code:ploygon.areaCode,
                                   mian:ploygon.areaMianDesc, 
                                   price: ploygon.commissionPrice, 
                                   distance: ploygon.areaDistance });
    var infoWindow = new BMap.InfoWindow(areaTmpWithValue);  
    map.openInfoWindow(infoWindow,centerPoint); 
  });
 
}
var  densityDrawOptions = { // 绘制参数
    type: "honeycomb", // 网格类型，方形网格或蜂窝形
    size: 30, // 网格大小
    globalAlpha: 0.7,
    unit: 'px', // 单位
    label: { // 是否显示文字标签
        show: true,
        color: "red",
        fontSize: "10px",
        backgroundColor: "white"
    },
    gradient: { // 显示的颜色渐变范围
        '0': 'blue',
        '0.6': 'cyan',
        '0.7': 'lime',
        '0.8': 'yellow',
        '1.0': 'red'
    }
}


var labelOptions = {
    color: "red",
    fontSize : "12px",
    fontFamily:"微软雅黑"
}

utils.districtOptions = {
  strokeColor:"#EE1010",    //边线颜色。
  strokeWeight: 2,       //边线的宽度，以像素为单位。
  strokeOpacity: 0.8,    //边线透明度，取值范围0 - 1。
  fillOpacity: 0.01,      //填充的透明度，取值范围0 - 1。
  enableEditing: false,
  strokeStyle: 'solid' //边线的样式，solid或dashed。
}

var styleOptions = {
  
    strokeColor:"#EE1010",    //边线颜色。
    fillColor:"green",      //填充颜色。当参数为空时，圆形将没有填充效果。
    strokeWeight: 2,       //边线的宽度，以像素为单位。
    strokeOpacity: 0.8,    //边线透明度，取值范围0 - 1。
    fillOpacity: 0.1,      //填充的透明度，取值范围0 - 1。
    enableEditing: false,
    strokeStyle: 'dashed' //边线的样式，solid或dashed。
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
      strokeWeight: 1,       //边线的宽度，以像素为单位。
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
  $("#ploygon-delete-index").val(ploygon.index);
  $("#delete-confirm-modal").modal("show");
 
}

function deletePloygonArea(e,ee,ploygon){
  $("#ploygon-delete-index").val(ploygon.index);
  $("#delete-confirm-modal").modal("show");
  var areaId = ploygon.areaId; 
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
