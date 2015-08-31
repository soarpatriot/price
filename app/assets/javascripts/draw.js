


$(function(){

  // 百度地图API功能
    var map = new BMap.Map('map-container');
    var poi = new BMap.Point(116.307852,40.057031);
    
    var ps=[
      {lat:40.06664,lng:116.296857},
      {lat:40.065149,lng:116.303684},
      {lat:40.059848,lng:116.299444},
      {lat:40.062774,lng:116.283131},
      {lat:40.067468,lng:116.286365},
      {lat:40.06664,lng:116.296857}
    ];

    var ps1= [
      {lat:40.06167,lng:116.325315},
      {lat:40.057197,lng:116.324453},
      {lat:40.057197,lng:116.331136},
      {lat:40.060676,lng:116.333005},
      {lat:40.06167,lng:116.325315}

    ];
    var p;
    var i=0;
    var pointsArr = []
   
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

    map.addOverlay(ploygon1)

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
