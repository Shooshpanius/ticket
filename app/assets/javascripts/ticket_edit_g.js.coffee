



@show_set_delay = () ->
  $("#setDelay").modal 'show'

@set_delay_off = (ticket_id) ->
  comm = $("#inputCommCloseText").val()
  $.ajax
    url: "/tickets/srv_set_delay_off"
    type: "POST"
    async: false
    data: {
      root_id: $("#inputDelayRoot").val()
    }
    success: () ->
      location.reload()

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
    $.ajax
      url: "/tickets/srv_close_ticket_comment_form"
      type: "get"
      async: false
      data: "ticket_id="+ticket_id
      success: (msg) ->
        $("#srv_close_ticket_comment_form").html msg

    $("#myModal").modal 'show'


@change_status_100 = (ticket_id) ->
  comm = $("#inputCommCloseText").val()
  $.ajax
      url: "/tickets/srv_change_g_status_100"
      type: "POST"
      async: false
      data: {
        comm: comm,
        ticket_id: ticket_id
      }
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

@change_in_scheduler = (ticket_id) ->
  $.ajax
    url: "/tickets/srv_change_g_in_scheduler"
    type: "POST"
    async: false
    data: {
      status: $("#inScheduler").is(':checked'),
      ticket_id: ticket_id
    }

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


  $("#startSchedulerDiv").on "changeDate", (e) ->
    $.ajax
      url: "/tickets/srv_change_g_sheduler_start"
      type: "POST"
      async: false
      data: {
        s_date: e.date.valueOf(),
        ticket_id: $("#ticket_id").val()
      }

  $("#stopSchedulerDiv").on "changeDate", (e) ->
    $.ajax
      url: "/tickets/srv_change_g_sheduler_stop"
      type: "POST"
      async: false
      data: {
        s_date: e.date.valueOf(),
        ticket_id: $("#ticket_id").val()
      }

  $('#inputCommText').wysihtml5()

  $("#inputDelayDate").datepicker
    firstDay: 1
    dateFormat: "yy-mm-dd"

  $('#startSchedulerDiv').datetimepicker
    pickSeconds: false
    language: 'ru'

  $('#stopSchedulerDiv').datetimepicker
    pickSeconds: false
    language: 'ru'

  $('#inputDelayTime').mask "99:99"

#  $("#comment_new").validate
#    rules:
#      inputCommText:
#        required: true
#
#    errorClass: "input_error"
#    errorElement: "em"
#    messages:
#      inputCommText: "*"
#
#    submitHandler: (form) ->
#      queryString = $("#comment_new").serialize()
#      $.ajax
#        url: "/tickets/srv_comment_g_new"
#        type: "POST"
#        async: false
#        data: queryString
#        success: (msg) ->
##          $("#comments").html $(msg)
#          location.reload()
#
#      false

  $("#setDelayForm").validate
    rules:
      inputDelayComment:
        required: true
        minlength: 3

    errorClass: "input_error"
    errorElement: "em"
    messages:
      inputDelayComment: "*"

    submitHandler: (form) ->
      queryString = $("#setDelayForm").serialize()
      $.ajax
        url: "/tickets/srv_set_delay"
        type: "POST"
        async: false
        data: queryString
        success: (msg) ->
#          $("#comments").html $(msg)
          location.reload()

      false