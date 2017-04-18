$(document).on 'turbolinks:load', ->
  $("article.search-form").hide()

  $(".menu-list a").click (e) ->
    e.preventDefault()

    # first, activate the link and deactivate the others
    $('.menu-list a').each ->
      $(@).removeClass('is-active')
    $(this).addClass('is-active')

    # which form do we want to show?
    toShow = $(this).attr('data')
    $("article.search-form").each ->
      art = $(@)
      art.slideUp('slow') unless art.attr('id') is toShow
    $("#"+toShow).slideDown('slow')

  $(".menu-list a").first().click()
