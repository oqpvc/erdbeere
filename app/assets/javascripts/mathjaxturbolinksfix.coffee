$ ->
  loadMathJax()
  $(document).on 'turbolinks:load', loadMathJax

loadMathJax = ->
  window.MathJax = null
  $.getScript "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/MathJax.js?config=TeX-AMS_HTML-full", ->
    MathJax.Hub.Config
      showMathMenu: false
      tex2jax: {inlineMath: [["$","$"],["\\(","\\)"]]}
