generate =
  code: (content) ->
    $.post 'code.html',
           content: $('#qr_content').val()
           (data) ->
             console.log('qr post success')
             $('#qr_container').html(data)

jQuery ->
  generate.code $('#qr_content').val #initial page load 
  $('#qr_generate').click (e) ->
    e.preventDefault
    container = $('#qr_container')
    container.fadeOut(300)
    generate.code $('#qr_content').val
    container.delay(200).fadeIn(800)

  $('#style_go').click ->
    clearQrStyles()
    $('td.qr_black').each ->
      $(this).addClass 'go_qr_black'
    $('td.qr_white').each ->
      $(this).addClass 'go_qr_white'

  $('#style_puzzle').click ->
    clearQrStyles()
    $('td.qr_black').each ->
      $(this).addClass 'crossword'
    $('td.qr_white').each ->
      $(this).addClass 'crossword'

  $('#style_shaped').click ->
    clearQrStyles()
    $('td.qr_black').each ->
      $(this).addClass 'crazy_shape'

  $('#style_jeweled').click ->
    clearQrStyles()
    $('td.qr_black').each ->
      $(this).addClass 'jeweled' 
  $('#style_boring').click ->
    console.log 'clear style classes'
    clearQrStyles()

clearQrStyles = ->
  console.log 'clearing styles'
  $('table.qr_table td').each ->
    $(this).removeClass 'go_qr_white'
    $(this).removeClass 'go_qr_black'
    $(this).removeClass 'crossword'
    $(this).removeClass 'crazy_shape'
    $(this).removeClass 'jeweled'


