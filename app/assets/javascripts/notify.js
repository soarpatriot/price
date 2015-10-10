
PNotify.prototype.options.styling = "bootstrap3";
var notify = notify || {};

notify.successOpt = function(title,text){
  var opts = {
          title: title,
          text: text,
          animate_speed: 1000, 
          type: "success",
          delay: 3000
  };
  return opts
}
notify.failOpt = function(title,text){
  var opts = {
          title: title,
          text: text,
          animate_speed: 1000, 
          type: "error",
          delay: 3000
  };
  return opts
}


var opts = {
        title: "Over Here",
        text: "Check me out. I'm in a different stack.",
        animate_speed: 1000, 
        delay: 2000
};
