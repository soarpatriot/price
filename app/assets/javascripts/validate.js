
var validate = validate || {};

validate.isBlank = function(value){
  if(value===""){
    return true;
  }else{
    return false; 
  }  
}

validate.isDigtalAndAlpha = function(value){
  var reg =  /^[0-9a-zA-Z]{1,5}$/g;
  return reg.test(value);
}

validate.valid = function(tip,message){
  return function(valid){
    if(!valid){
      tip.text(message);
    }
    return valid;
  }
}
