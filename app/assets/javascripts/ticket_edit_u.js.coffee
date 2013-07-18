
$(document).ready ($) ->


  $("#comment_new").validate
    rules:
      inputCommText:
        required: true



    errorClass: "input_error"
    errorElement: "em"
    messages:
      inputCommText: "*"

    submitHandler: (form) ->
      queryString = $("#comment_new").serialize()
      $.ajax
        url: "/tickets/srv_comment_u_new"
        type: "POST"
        async: false
        data: queryString
        success: (msg) ->
#          $("#comments").html $(msg)
          location.replace ''

      false