
@show_add_supply = () ->
#  $("#addSupply").modal 'show'

  $("#addSupply").modal(
    backdrop: true
    keyboard: true
  ).css
    width: "800px"
    "margin-left": ->
      -($(this).width() / 2)


$(document).ready ($) ->

  $("#inputAddDate").datepicker
    firstDay: 1
    dateFormat: "yy-mm-dd"


  $("#addSupplyForm").validate
    rules:
      inputAddName:
        required: true
      inputAddSpec:
        required: true
      inputAddMeasure:
        required: true
      inputAddCnt:
        required: true
      inputAddDate:
        required: true
      inputAddSupplier:
        required: true

    errorClass: "input_error"
    errorElement: "em"
    messages:
      inputAddName: "*"
      inputAddSpec: "*"
      inputAddMeasure: "*"
      inputAddCnt: "*"
      inputAddDate: "*"
      inputAddSupplier: "*"

    submitHandler: (form) ->
      queryString = $("#addSupplyForm").serialize()
      $.ajax
        url: "/supply/srv_add_supply_data"
        type: "POST"
        async: false
        data: queryString
        success: (msg) ->
#          $("#comments").html $(msg)
          location.reload()

      false
