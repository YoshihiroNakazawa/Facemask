$(document).on 'turbolinks:before-change', ->
  console.log('turbolinks:before-change')
$(document).on 'turbolinks:fetch', ->
  console.log('turbolinks:fetch')
$(document).on 'turbolinks:receive', ->
  console.log('turbolinks:receive')
$(document).on 'turbolinks:render', ->
  console.log('turbolinks:render')
$(document).on 'turbolinks:update', ->
  console.log('turbolinks:update')
$(document).on 'turbolinks:restore', ->
  console.log('turbolinks:restore')
$(document).on 'turbolinks:before-render', ->
  console.log('turbolinks:before-render')
$(document).on 'turbolinks:after-remove', ->
  console.log('turbolinks:after-remove')
$(document).on 'ready', ->
  console.log('ready!')

debugprint = ->
  console.log('load')

$(document).on('turbolinks:load', debugprint)
