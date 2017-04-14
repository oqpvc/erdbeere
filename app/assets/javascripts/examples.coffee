# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(window).ready ->
  $('#falsehoods li strong').each (index, element) =>
    $(element).text($(element).text().replace /is/, 'is not')

