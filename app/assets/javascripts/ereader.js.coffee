$(document).ready ->
  $("img").lazyload()
  $('pre code, div.code').each (i, e)->
    hljs.highlightBlock(e)

$(document).on 'page:before-change', ->
  $('@loading').removeClass('hidden')

$(document).on 'page:update', ->
  $('@loading').addClass('hidden')
  $('pre code, div.code').each (i, e)->
    hljs.highlightBlock(e)

$(document).on 'mouseenter', '@tooltip', ->
  $('@tooltip').tooltip()

