# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@ticket_open = (ticket_type, ticket_id) ->

  url = "/tickets/ticket_edit/"+ticket_type+"_"+ticket_id
  location.replace(url)

