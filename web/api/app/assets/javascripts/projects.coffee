# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'turbolinks:load', ->

  console.log("gon >> ", gon)

  # プロジェクト一覧のソート
  $('.js_project-filter').change ->
    document.projectFilter.submit();

  # 参加プロジェクト一覧のソート
  $('.js_joined-project-filter').change ->
    document.joinedProjectFilter.submit();


