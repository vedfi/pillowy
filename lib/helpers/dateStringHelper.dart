class DateStringHelper{

  static String HourMinute2Digits(DateTime dt){
    return Hour2Digits(dt) + ':' + Minute2Digits(dt);
  }

  static String Hour2Digits(DateTime dt){
    var str = dt.hour.toString();
    if(str.length == 1){
      str = '0'+str;
    }
    return str;
  }

  static String Minute2Digits(DateTime dt){
    var str = dt.minute.toString();
    if(str.length == 1){
      str = '0'+str;
    }
    return str;
  }

}