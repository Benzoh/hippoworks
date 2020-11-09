const count = {

  to_time: function(secs) {
    var min = Math.floor(secs / 60);
    var hour = 00;
    if (min > 60) {
      hour = Math.floor(min / 60);
      min = min - hour * 60
    }
    // console.log('hour >>> ', hour);
    var sec = secs % 60;
    if (hour < 10) { hour = "0" + hour; }
    if (min < 10) { min = "0" + min; }
    if (sec < 10) { sec = "0" + sec; }
    return { hour: hour, min: min, sec: sec };
  },

  to_sec: function(time_arr) {
    return time_arr.h * 3600 + time_arr.m * 60 + parseInt(time_arr.s);
  }

}