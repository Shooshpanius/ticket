
$(document).ready ($) ->

  $("#inputDateTo").datepicker
    firstDay: 1
    dateFormat: "dd-mm-yy"




  $("#ticket_new").validate
    rules:
      inputIsp:
        required: true
      inputTopic:
        required: true
      inputText:
        required: true
      inputDateTo:
        required: true



    errorClass: "input_error"
    errorElement: "em"
    messages:
      inputIsp: "*"
      inputTopic: "*"
      inputText: "*"
      inputDateTo: "*"

    submitHandler: (form) ->
      queryString = $("#ticket_new").serialize()
      $.ajax
        url: "/tickets/srv_ticket_new"
        type: "POST"
        async: false
        data: queryString
        success: (msg) ->
#          location.replace "/admin/groups"

      false