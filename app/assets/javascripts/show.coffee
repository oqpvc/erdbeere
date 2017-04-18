$(document).on 'turbolinks:load', ->
  $("article.derivation").hide()

  $(".toggle-derivation").click (e) ->
    # first, activate the link and deactivate the others
    $('i', this).toggleClass('fa-minus-square')
    $('i', this).toggleClass('fa-plus-square')

    # which form do we want to show?
    toShow = $(this).attr('id')
    $("#usage-of-#{toShow}").slideToggle()

