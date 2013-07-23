# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ($) ->


  $("#menu_text").html " Ticket system / Новый пользователь"


  $("#user_new").validate
    rules:
      inputLogin:
        required: true
      inputF:
        required: true
      inputI:
        required: true
      inputO:
        required: true

    errorClass: "input_error"
    errorElement: "em"
    messages:
      inputLogin: "*"
      inputF: "*"
      inputI: "*"
      inputO: "*"

    submitHandler: (form) ->
      queryString = $("#user_new").serialize()
      $.ajax
        url: "/admin/users/srv_user_new"
        type: "POST"
        async: false
        data: queryString
        success: (msg) ->
          location.replace "/admin/users"

      false

