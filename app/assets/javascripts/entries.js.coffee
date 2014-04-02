$(document).on 'click', '@check, @star, @flag', ->
  $(@).toggleClass('check')

$(document).on 'click', '.index_entry', ->
  $(@).addClass('read')
