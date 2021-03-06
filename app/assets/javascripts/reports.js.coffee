# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@show_text = (root_id) ->

  $.ajax
    url: "/reports/srv_activity_show_text"
    type: "get"
    async: false
    data: "root_id="+root_id
    success: (msg) ->
      $("#ticketText").html msg
      $("#setDelay").modal 'show'
    false

$(document).ready ($) ->



  $("#inputDateFrom").datepicker
    firstDay: 1
    dateFormat: "dd-mm-yy"

  $("#inputDateTo").datepicker
    firstDay: 1
    dateFormat: "dd-mm-yy"


  $("#activity").validate
    rules:
      inputDateFrom:
        required: true
      inputDateTo:
        required: true




    errorClass: "input_error"
    errorElement: "em"
    messages:
      inputDateFrom: "*"
      inputDateTo: "*"

    submitHandler: (form) ->
      queryString = $("#activity").serialize()
      $.ajax
        url: "/reports/srv_activity"
        type: "POST"
        async: false
        data: queryString
        success: (msg) ->
          $("#act").html msg

      false