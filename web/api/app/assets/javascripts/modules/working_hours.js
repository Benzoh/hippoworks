let workingHours = {

  start: function(target_obj) {
    console.log('start...');
    target_obj.parent().addClass('is_count');
    workingHours.display_time(target_obj, 300);
  },

  stop: function(target_obj) {
    console.log('stop...');
    target_obj.parent().removeClass('is_count');
    var time_arr = { h: target_obj.parent().find('.hour').text(), m: target_obj.parent().find('.min').text(), s: target_obj.parent().find('.sec').text() }
    var workingHourId = target_obj.parent().find('#working_hour_id').val();
    var task_id = 6;
    // 保存処理
    workingHours.save(workingHourId, task_id, count.to_sec(time_arr));
  },

  save: function(workingHourId, task_id, secs) {
    $.ajax({
      url: '/working_hours/' + workingHourId,
      type: 'PATCH',
      data:{
        'project_id': gon.project.id,
        'task_id': task_id,
        'secs': secs
      }
    })
    // Ajaxリクエストが成功した時発動
    .done( (data) => {
        console.log("[SUCCESS]: Working time saved.");
    })
    // Ajaxリクエストが失敗した時発動
    .fail( (data) => {
        console.log("[ERROR]: could not saved.");
    })
  },

  display_time: function(target_obj, secs) {
    var time = count.to_time(secs);
    console.log(time);
    target_obj.parent().find(".hour").text(time.hour);
    target_obj.parent().find(".min").text(time.min);
    target_obj.parent().find(".sec").text(time.sec);
  },

  init: function() {
    $(document).on('click', ".count_start", function() {
      workingHours.start($(this));
    });
    $(document).on('click', ".count_stop", function() {
      workingHours.stop($(this));
    });
  }

}

$(document).on('turbolinks:load', function() {
  workingHours.init();
  // timer.test();
});