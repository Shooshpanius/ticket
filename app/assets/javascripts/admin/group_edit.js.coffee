$(document).ready ($) ->


  $("#menu_text").html " Ticket system / пользователи"


  $("#group_edit").validate
    rules:
      inputName:
        required: true



    errorClass: "input_error"
    errorElement: "em"
    messages:
      inputName: "*"

    submitHandler: (form) ->
      queryString = $("#group_edit").serialize()
      $.ajax
        url: "/admin/groups/srv_group_edit"
        type: "POST"
        async: false
        data: queryString
        success: (msg) ->
          location.replace ""

      false