
@change_status = (status, ticket_id) ->
  $.ajax
    url: "/tickets/srv_change_u_status"
    type: "POST"
    async: false
    data: "status="+status+"&ticket_id="+ticket_id
    success: () ->
      location.replace ""


$(document).ready ($) ->

  $('#inputCommText').wysihtml5()


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