
$('#inputText').wysihtml5()

$("#inputDateTo").datepicker
  firstDay: 1
  dateFormat: "dd-mm-yy"


$("#supply_new").validate
  rules:
    inputIsp:
      required: true
    inputTopic:
      required: true
#    inputText:
#      required: true
#    inputDateTo:
#      required: true




  errorClass: "input_error"
  errorElement: "em"
  messages:
    inputIsp: "*"
    inputTopic: "*"
#    inputText: "*"
#    inputDateTo: "*"

  submitHandler: (form) ->
    queryString = $("#supply_new").serialize()
    $.ajax
      url: "/supply/srv_supply_new"
      type: "POST"
      async: false
      data: queryString
      success: (msg) ->
        location.replace "/supply/supply_edit/" + msg
    false