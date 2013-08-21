# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@ticket_open = (ticket_type, ticket_id) ->

  url = "/tickets/ticket_edit/"+ticket_type+"_"+ticket_id
  location.replace(url)

@group_list = (group_id, ticket_id) ->

  $.ajax
    url: "/tickets/srv_get_group_list"
    type: "POST"
    async: false
    data: "group_id="+group_id+"&ticket_id="+ticket_id
    success: (msg) ->
      $("#gr-list").html msg


@change_executor = (user_id, ticket_id) ->
  $.ajax
    url: "/tickets/srv_change_executor_leader"
    type: "POST"
    async: false
    data: "executor_id="+user_id+"&ticket_id="+ticket_id
    success: () ->
      location.reload()

$(document).ready ($) ->


  $("#myModal").on "hidden", ->
    $("#gr-list").html ""
