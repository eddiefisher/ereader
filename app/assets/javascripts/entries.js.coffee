$(document).on 'click', '@check, @star, @flag', ->
  if $(@).hasClass('uncheck')
    $(@).removeClass('uncheck')
    $(@).addClass('check')
  else
    $(@).removeClass('check')
    $(@).addClass('uncheck')
