# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ($) ->
  scheduler.config.server_utc = true
  scheduler.config.xml_date = "%Y-%m-%d %H:%i"
  scheduler.init "scheduler_here", new Date('2014, 01, 1'), "month"
#  scheduler.callEvent("onOptionsLoad", []);
  scheduler.config.hour_size_px = 44;

  scheduler.config.first_hour = 7;
  scheduler.config.last_hour = 22;

  scheduler.load("/plan/records");

#  dp = new dataProcessor("/plan/dbaction");
#  dp.init(scheduler);
#  dp.setTransactionMode("POST",false);

