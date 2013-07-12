# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


@user_delete = (user_id) ->
  if confirm("Подтвердите удаление")
    $.ajax
      url: "/admin/users/srv_user_delete"
      type: "POST"
      async: false
      data: 'user_id='+user_id
      success: () ->
        location.replace ""
  else


$(document).ready ($) ->


  $("#menu_text").html " Ticket system / пользователи"

