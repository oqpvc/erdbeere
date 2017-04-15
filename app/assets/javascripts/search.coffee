$(document).on 'turbolinks:load', ->
  $("form").hide()

  $(".menu-list a").click (e) ->
    e.preventDefault()

    # first, activate the link and deactivate the others
    $('.menu-list a').each ->
      $(@).removeClass('is-active')
    $(this).addClass('is-active')

    # which form do we want to show?
    toShow = $(this).attr('data')
    $("form").each ->
      f = $(@)
      f.slideUp('slow') unless f.attr('id') is toShow
    $("#"+toShow).slideDown('slow')

