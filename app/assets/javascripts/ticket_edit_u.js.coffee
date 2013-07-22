
@change_status = (ticket_id) ->
  $.ajax
    url: "/tickets/srv_change_u_status"
    type: "POST"
    async: false
    data: "status="+$("select#inputCompleted").val()+"&ticket_id="+ticket_id
    success: () ->
      location.replace ""


$(document).ready ($) ->

  $('#inputCommText').wysihtml5()


  $("#slider-range-max").slider
    range: "max"
    min: 0
    max: 100
    value: 2
    slide: (event, ui) ->
      $("#amount").val ui.value

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