$(document).ready ->
  $("img").lazyload()

$(document).on 'page:before-change', ()->
  $('@loading').removeClass('hidden')

$(document).on 'page:update', ->
  $('@loading').addClass('hidden')

$(document).on 'mouseenter', '@tooltip', ->
  $('@tooltip').tooltip()

