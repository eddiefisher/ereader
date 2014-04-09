$(document).on 'click', '@check', ->
  $(@).toggleClass('check')
  $checkbox = $(@).closest('.actions').find('input[type="checkbox"]')
  if $checkbox.is ':checked'
    $checkbox.prop('checked', false)
  else
    $checkbox.prop('checked', true)

$(document).on 'click', '@check_all', ->
  $(@).toggleClass('check')
  $('@check').toggleClass('check')

  $('@check').each (i, v)->
    $checkbox = $(v).closest('.actions').find('input[type="checkbox"]')
    if $checkbox.is ':checked'
      $checkbox.prop('checked', false)
    else
      $checkbox.prop('checked', true)

$(document).on 'click', '.index_entry', ->
  $(@).addClass('read')

$(document).on 'click', '.index_entry', ->
  $(@).addClass('read')

$(document).on 'click', '@read_batch_action', ->
  data = []
  $('@check.check').each (i,e)->
    data.push $(e).closest('.index_entry').data('id')
