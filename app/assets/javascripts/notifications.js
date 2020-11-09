$(document).on('turbolinks:load', function() {

  let notification = {

    notificationItems: null,
    notificationCount: null,

    fetch: function() {
      $.ajax({
        url: '/notifications.json',
        type: 'GET',
      })
      // # Ajaxリクエストが成功した時発動
      .done( (data) => {
        console.log('notifications >> ', data);
        notification.setNotificationCount(data);
        if ( data.length > 0 ) {
          notification.setNotificationItems(data);
          notification.showNotificationCount();
        } else {
          notification.hideNotificationCount();
        }
      })
      // # Ajaxリクエストが失敗した時発動
      .fail( (data) => {
        console.log("[ERROR]: could not get items.");
      })
    },

    fetchWithInterval: function() {
      timer = setInterval(function() {
        notification.fetch();
        // alert("Fetched.");
        notification.showNotificationCount();
        notification.showUpdateInfo();
      // }, 3000);
      }, 60000 * 5); // 5分おき
    },

    showNotificationCount: function() {
      if (notification.notificationCount == 0) {
        return;
      }
      var html = `<span class=\"js_notification_count badge badge-danger ml-1\">${notification.notificationCount}</span>`;
      if ( $('body').find('.js_notification_count').length > 0 ) {
        $('.js_notification_count').text(notification.notificationCount);
      } else {
        $('.js_notifications-btn').append(html);
      }
    },

    showUpdateInfo: function() {
      if (notification.notificationCount > 0) {
        if ( notification.matchShowThread() == false ) {
          return
        }
        var html = `
          <div id="update-info" class="alert alert-danger text-center" role="alert">
            <a class="text-danger" href="javascript:location.reload();">コメントの更新があります。</a>
          </div>`;
        if ( $('.js_update-info').children('#update-info').length == 0 ) {
          $('.js_update-info').prepend(html);
        }
      }
    },

    matchShowThread: function() {
      let obj = notification.notificationItems
      let flag = false
      Object.keys(obj).forEach(elm => {
        if ( obj[elm].parent_type in gon && gon[obj[elm].parent_type]['id'] == obj[elm].parent_id ) {
          flag = true
          return
        }
      });
      return flag
    },

    hideNotificationCount: function() {
      $('.js_notification_count').remove();
    },

    setNotificationCount: function(resData) {
      notification.notificationCount = resData.length
    },

    setNotificationItems: function(resData) {
      notification.notificationItems = Object.assign({}, resData);
    },

  }

  // main
  if (gon.login) {
    notification.fetch();
    notification.fetchWithInterval();
  }

  // 通知表示
  $('.js_notifications-btn').on('click', function () {
    $('.m_favorite-list').addClass('close');
    $('.m_like-notifications').addClass('close');

    if ( $('.m_notifications').hasClass('close') ) {
      // TODO: ローディング入れる
      // TODO: remote: trueでいいような
      $.ajax({
        url: '/notifications/fetch',
        type: 'GET',
      })
      .done( (data) => {
        // console.log(data);
        console.log("[ajax]: fetched.");
        // TODO: ローディング消す
      })
      .fail( (data) => {
        console.log("[ERROR]: could not get items.");
      })
    }

    $('.m_notifications').toggleClass('close');
    return false;
  });

  // for like
  $('.js_like-notifications-btn').on('click', function() {
    $('.m_notifications').addClass('close');
    $('.m_favorite-list').addClass('close');
    $('.m_like-notifications').toggleClass('close');
    return false;
  })

  // for favorite
  $('.js_favorite-list-btn').on('click', function() {
    $('.m_notifications').addClass('close');
    $('.m_like-notifications').addClass('close');
    $('.m_favorite-list').toggleClass('close');
    return false;
  })

});
