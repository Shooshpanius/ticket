$(document).ready ($) ->


  $("#menu_text").html " Ticket system / пользователи"


  $("#group_new").validate
    rules:
      inputName:
        required: true



    errorClass: "input_error"
    errorElement: "em"
    messages:
      inputName: "*"

    submitHandler: (form) ->
      queryString = $("#group_new").serialize()
      $.ajax
        url: "/admin/groups/srv_group_new"
        type: "POST"
        async: false
        data: queryString
        success: (msg) ->
#          location.replace "/admin/groups"

      false