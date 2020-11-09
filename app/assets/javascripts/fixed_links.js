$(document).on('turbolinks:load', function() {

  $('body').on('click', '.js_fixed-link-close', function() {
    $(this).parents('.fixed-link').hide()
  })

})