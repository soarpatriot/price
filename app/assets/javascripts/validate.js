
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
validate.isDigtalAndAlpha3 = function(value){
  var reg =  /^[A-Z]([0-9]{2})?$/g;
  return reg.test(value);
}

validate.lethThen6 = function(value){
  if(value.length > 6){
    return false;
  }  
  return  true;
}
validate.valid = function(tip,message){
  return function(valid){
    if(!valid){
      tip.text(message);
    }
    return valid;
  }
}
