
@add_task = (root_id) ->
  $.ajax
    url: "/plan/srv_add_task"
    type: "POST"
    async: false
    data: {
      task_to: $("#task_to").val(),
      startScheduler: $("#startScheduler").val().valueOf(),
      stopScheduler: $("#stopScheduler").val().valueOf(),
      root_id: root_id
    }
    success: () ->
      location.reload()


$(document).ready ($) ->

  $('#startSchedulerDiv').datetimepicker
    pickSeconds: false
    language: 'ru'

  $('#stopSchedulerDiv').datetimepicker
    pickSeconds: false
    language: 'ru'