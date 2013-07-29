
$(document).ready ($) ->

  $('#inputText').wysihtml5()





  $("#problem_new").validate
    rules:
      inputIsp:
        required: true
      inputTopic:
        required: true
      inputText:
        required: true





    errorClass: "input_error"
    errorElement: "em"
    messages:
      inputIsp: "*"
      inputTopic: "*"
      inputText: "*"


    submitHandler: (form) ->
      queryString = $("#problem_new").serialize()
      $.ajax
        url: "/problems/srv_problem_new"
        type: "POST"
        async: false
        data: queryString
        success: (msg) ->
          location.replace "/problems/Out"

      false