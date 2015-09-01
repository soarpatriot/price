


$(function(){

  // 百度地图API功能
    var map = new BMap.Map('map-container');
    var poi = new BMap.Point(116.307852,40.057031);
    var cityId = $("#city-id").val();
  
    var overlays = [];
    var overlaycomplete = function(e){
        console.log(e.overlay);
        var points = e.overlay.Q;
        $.map(points,function(p,i){
          console.log(i);
          console.log("lat:"+p.lat+",lng:"+p.lng);
        })
        //console.log(e.overlay.Q);
        overlays.push(e.overlay);
    };
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


    map.centerAndZoom(poi, 15);
    map.enableScrollWheelZoom();  
    var ploygons = [];
    $.get("http://localhost:9000/v1/stations/city.json",{city_id:cityId},function(data){
      console.log(data); 
      $.each(data,function(key,station){
        //console.log(station); 
        var arr = convertToPointsOjeArray(station.points);
        var ploygon = new BMap.Polygon(arr,styleOptions);
        ploygon.stationId = station.id;
        ploygon.addEventListener("dblclick",function(){
          ploygon.enableEditing()
          //console.log("edit");
        });
        ploygon.addEventListener("lineupdate",function(type,target){
          
          //console.log("type:"+type);
          //console.log("type:"+ploygon.stationId);
          var points = ploygon.getPath();
          //console.log("points:"+points);
          var pos = convertObjToDataPoints(points);

          var data = {id:ploygon.stationId,points:pos}
           
          //console.log("data:"+JSON.stringify(data));

        });
        ploygons.push(ploygon);
        map.addOverlay(ploygon);
      });

      $("#save-btn").click(function(){
         var i=0;
         var data;
         var points;
         var pos;
         var stationId;
         var dataStr;
         for(i=0; i<ploygons.length;i++){
            points = ploygons[i].getPath();
            pos = convertObjToDataPoints(points);

            stationId = ploygons[i].stationId;
            dataStr = "{id:"+stationId+",points:"+pos+"}"
            data = {id:ploygons[i].stationId,points:pos}
            console.log("data:"+data);
            var dataStr= JSON.stringify(data);
            console.log("data:" + JSON.stringify(data));
            $.ajax({
              type:"put",
              dataType: "json",
              contentType: "application/json",
              url: "http://localhost:9000/v1/stations/"+stationId+".json", 
              headers: {"X-HTTP-Method-Override": "put"}, 
              data: JSON.stringify(data)
            }); 
         }
      });

    });   

    function convertObjToDataPoints(points){
      //console.log("points:"+points);
      var pos = [];
      var str = "["
      var p1 = "[";
      $.each(points,function(key,point){
        var p = {lantitude:point.lat,longitude:point.lng};
        //console.log("type:"+point.lng);
        //console.log("type:"+point.lat);
        //p1 = p1 + "{\"lantitude\":"+point.lat+",\"longitude\":"+point.lng+"}," 
        p1 = p1 + "{lantitude:"+point.lat+",longitude:"+point.lng+"}," 
        pos.push(p);
      })
      p1 = p1.substr(0,p1.length-1);
      p1 = p1 + "]"
      console.log("pos:"+p1);
      return pos;
      //return pos;
    } 
    /** 
    var arr = poArr(ps)
    var ploygon = new BMap.Polygon(arr,styleOptions);
    ploygon.addEventListener("dblclick",function(){
      ploygon.enableEditing()
    });
    ploygon.addEventListener("mouseover",function(type,target,point,pixel){
      console.log(target);
      console.log(type);
      console.log(point);
    })
    map.addOverlay(ploygon);
 
    arr = poArr(ps1)
    var ploygon1 = new BMap.Polygon(arr,styleOptions);
    ploygon1.addEventListener("dblclick",function(){
      ploygon1.enableEditing()
    });
    ploygon1.addEventListener("mouseover",function(type,target,point,pixel){
      console.log(target);
      console.log(type);
      console.log(point);
    })

    map.addOverlay(ploygon1)**/

    //实例化鼠标绘制工具
    var drawingManager = new BMapLib.DrawingManager(map, {
        isOpen: false, //是否开启绘制模式
        enableDrawingTool: true, //是否显示工具栏
        drawingToolOptions: {
            anchor: BMAP_ANCHOR_TOP_RIGHT, //位置
            offset: new BMap.Size(5, 5), //偏离值
        },
        circleOptions: styleOptions, //圆的样式
        polylineOptions: styleOptions, //线的样式
        polygonOptions: drawOptions, //多边形的样式
        rectangleOptions: styleOptions //矩形的样式
    });  
   //添加鼠标绘制工具监听事件，用于获取绘制结果
    drawingManager.addEventListener('overlaycomplete', overlaycomplete);


       
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
 
})
