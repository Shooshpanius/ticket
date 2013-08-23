
@change_status = (ticket_id) ->
  status = $("select#inputCompleted").val()
  unless parseInt(status) is 100
    $.ajax
      url: "/tickets/srv_change_g_status"
      type: "POST"
      async: false
      data: "status="+status+"&ticket_id="+ticket_id
      success: () ->
        location.reload()
  else
    $("#myModal").modal 'show'


@change_status_100 = (ticket_id) ->
  comm = $("#inputCommCloseText").val()
  $.ajax
      url: "/tickets/srv_change_g_status_100"
      type: "POST"
      async: false
      data: "comm="+comm+"&ticket_id="+ticket_id
      success: () ->
        location.reload()


@change_actual = (ticket_id) ->
  $.ajax
    url: "/tickets/srv_change_g_actual"
    type: "POST"
    async: false
    data: "status="+$("#inputActual").is(':checked')+"&ticket_id="+ticket_id
    success: () ->
#      location.replace ""

@change_executor_leader = (ticket_id) ->
  $.ajax
    url: "/tickets/srv_change_executor_leader"
    type: "POST"
    async: false
    data: "executor_id="+$("select#executor").val()+"&ticket_id="+ticket_id
    success: () ->
      location.reload()

@change_executor_member = (ticket_id) ->
  $.ajax
    url: "/tickets/srv_change_executor_member"
    type: "POST"
    async: false
    data: "ticket_id="+ticket_id
    success: () ->
      location.reload()



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
        url: "/tickets/srv_comment_g_new"
        type: "POST"
        async: false
        data: queryString
        success: (msg) ->
#          $("#comments").html $(msg)
          location.reload()

      false