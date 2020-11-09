var timer = {

  // タイマーの動作・停止の状態を表すフラグ
  isRunning: null,
  // タイマーID
  timerId: null,
  // 残り時間（秒数）
  initial_secs: null,
  secs: null,

  // [スタート]ボタン押下時に呼出されるメソッド
  startTimer: function() {
    console.log("start!!");
    if (timer.isRunning == true) {
      return;
    } else {
      timer.isRunning = true;
    }
    timer.display_each_sec();
  },

  // [ストップ]ボタン押下時に呼出されるメソッド
  stopTimer: function() {
    console.log(timer.secs);
    if (timer.isRunning == false) {
      return;
    } else {
      clearInterval(timer.timerId);
      timer.isRunning = false;
    }
  },

  // タイマー終了時に呼出されるメソッド
  clearTimer: function() {
    clearInterval(timer.timerId);
    timer.secs = timer.initial_secs;
    timer.display_time(timer.secs);
    this.isRunning = false;
  },

  display_time: function(secs) {
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

    $("#id_disp .hour").text(hour);
    $("#id_disp .min").text(min);
    $("#id_disp .sec").text(sec);
    console.log(hour + ":" + min + ":" + sec);
  },

  display_each_sec: function() {
    // 1秒毎に残り時間を表示
    timer.timerId = setInterval(function() {
      timer.secs--;

      timer.display_time(timer.secs);

      if (timer.secs == 0) {
        alert("経過しました。");
        timer.clearTimer();
      }
    }, 1000);
  },

  init: function(secs) {
    // 変数の初期化
    timer.isRunning = false;
    timer.initial_secs = secs;
    timer.secs = secs;

    timer.display_time(secs);

    $(".id_start").on('click', function() { timer.startTimer(); });
    // $("#id_start").on('click', function() { timer.startTimer(); });
    $("#id_stop").on("click", function() { timer.stopTimer(); });
    $('#id_clear').on("click", function() { timer.clearTimer(); });
  },

  test: function() {
    alert('!!');
  }
}

// $(document).on('turbolinks:load', function() {
//   timer.init(gon.timer.secs);
// });