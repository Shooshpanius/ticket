# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ($) ->


  $("#menu_text").html " Ticket system / пользователи"


  $("#user_edit").validate
    rules:
      inputLogin:
        required: true



    errorClass: "input_error"
    errorElement: "em"
    messages:
      inputLogin: "*"

    submitHandler: (form) ->
      queryString = $("#user_edit").serialize()
      $.ajax
        url: "/admin/users/srv_user_edit"
        type: "POST"
        async: false
        data: queryString
        success: (msg) ->
          location.replace "/admin/users"

      false

