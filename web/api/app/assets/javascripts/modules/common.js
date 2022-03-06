$(document).on('turbolinks:load', function() {

  // 標準作業入力表示
  $('.js_standard-operations-form-activate-btn').on('click', function() {
    $('.js_standard-operations-form').toggleClass('show');
  });

  // イメージアップロードの変更した画像を表示する
  $('#image-uploader').on('change', function() {
    var file = this.files[0];
    if (file !== null) {
      // console.log(window.URL.createObjectURL(file));
      var src = window.URL.createObjectURL(file);
      $('#uploaded-image').attr('src', src);
    }
  });

  // Comments: cmd+enter to submit
  const commentTextarea = document.getElementById("js_comment-textarea");
  const commentSubmit = document.getElementById("js_comment-submit");
  if (commentTextarea) {
    commentTextarea.addEventListener('keydown', function(e) {
      if(e.keyCode == 13 && e.metaKey) {
        commentSubmit.click();
      }
    });
  }

  $(document).on('click', '.js_fileupload-screen-close', function() {
    $('#share-file-uploader').html("");
  });

});
