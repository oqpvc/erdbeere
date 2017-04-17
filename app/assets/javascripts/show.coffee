$(document).on 'turbolinks:load', ->
  $("article.derivation").hide()

  $(".toggle-derivation").click (e) ->
    # first, activate the link and deactivate the others
    $(this).toggleClass('fa-minus-square')
    $(this).toggleClass('fa-plus-square')

    # which form do we want to show?
    toShow = $(this).attr('id')
    $("#usage-of-#{toShow}").slideToggle('slow')


