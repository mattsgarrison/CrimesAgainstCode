data_cells = 0
altered_cells = 0
ecc = 0.30

jQuery ->
  # Calculate initial values

  mpmetrics.track("Main Page Load")
  ecc = 0.30
  updateCount(altered_cells)

  #$('#qr_content').
  # Stuff to do on page load to set up the initial state of the page.
  generate.code $('#qr_content').val #initial page load 
  $('#qr_dark_colorpicker').ColorPicker({
    color: '#000000'
    onShow: (colorpkr) ->
      $(colorpkr).fadeIn(500)
      false
    onHide: (colorpkr) ->
      $(colorpkr).fadeOut(500)
      false
    onChange: (hsb, hex, rgb) ->
      $('td.qr_black').each ->
        $(this).css('backgroundColor', '#'+hex)
      $('#qr_dark_colorpicker span').html('#'+hex)
      $('#qr_dark_colorpicker span').css('backgroundColor', '#'+hex)

  })
  $('#qr_dark_colorpicker span').css('backgroundColor', '#000000')

  $('#qr_light_colorpicker').ColorPicker({
    color: '#ffffff'
    onShow: (colorpkr) ->
      $(colorpkr).fadeIn(500)
      false
    onHide: (colorpkr) ->
      $(colorpkr).fadeOut(500)
      false
    onChange: (hsb, hex, rgb) ->
      $('td.qr_white').each ->
        $(this).css('backgroundColor', '#'+hex)

      $('.qr_table tbody').css('backgroundColor', '#'+hex)
      $('#qr_light_colorpicker span').html('#'+hex)
      $('#qr_light_colorpicker span').css('backgroundColor', '#'+hex)
  })
  $('#qr_light_colorpicker span').css('backgroundColor', '#ffffff')

  $('#qr_dark_edit_colorpicker').ColorPicker({
    color: '#333333'
    onShow: (colorpkr) ->
      $(colorpkr).fadeIn(500)
      false
    onHide: (colorpkr) ->
      $(colorpkr).fadeOut(500)
      false
    onChange: (hsb, hex, rgb) ->
      $('td.qr_black_clicked').each ->
        $(this).css('backgroundColor', '#'+hex)
      $('#qr_dark_edit_colorpicker span').html('#'+hex)
      $('#qr_dark_edit_colorpicker span').css('backgroundColor', '#'+hex)

  })
  $('#qr_dark_edit_colorpicker span').css('backgroundColor', '#333333')


  $('#qr_light_edit_colorpicker').ColorPicker({
    color: '#b3b3b3'
    onShow: (colorpkr) ->
      $(colorpkr).fadeIn(500)
      false
    onHide: (colorpkr) ->
      $(colorpkr).fadeOut(500)
      false
    onChange: (hsb, hex, rgb) ->
      $('td.qr_white_clicked').each ->
        $(this).css('backgroundColor', '#'+hex)

      $('.qr_table tbody').css('backgroundColor', '#'+hex)
      $('#qr_light_edit_colorpicker span').html('#'+hex)
      $('#qr_light_edit_colorpicker span').css('backgroundColor', '#'+hex)
  })
  $('#qr_light_edit_colorpicker span').css('backgroundColor', '#b3b3b3')


  # Validators

  # Block form submit.
  $('#qr_form').submit (e) ->
    e.preventDefault
    false
  $('#qr_generate').click (e) ->
    e.preventDefault
    container = $('#qr_container')
    container.fadeOut(300)
    generate.code $('#qr_content').val
    container.delay(200).fadeIn(800)
    altered_cells = 0
    updateCount(altered_cells)
    $('#style_boring').attr('checked', true)
    mpmetrics.track("Generated new code")

  $('#style_go').click ->
    clearQrStyles()
    $('td.qr_black').each ->
      $(this).addClass 'go_qr_black'
    $('td.qr_white').each ->
      $(this).addClass 'go_qr_white'
    $('td.qr_black_clicked').each ->
      $(this).addClass 'go_qr_black'
    $('td.qr_white_clicked').each ->
      $(this).addClass 'go_qr_white'

  $('#style_puzzle').click ->
    clearQrStyles()
    $('td.qr_black').each ->
      $(this).addClass 'crossword'
    $('td.qr_white').each ->
      $(this).addClass 'crossword'
    $('td.qr_black_clicked').each ->
      $(this).addClass 'crossword'
    $('td.qr_white_clicked').each ->
      $(this).addClass 'crossword'

  $('#style_shaped').click ->
    clearQrStyles()
    $('td.qr_black').each ->
      $(this).addClass 'crazy_shape'
    $('td.qr_black_clicked').each ->
      $(this).removeClass 'crazy_shape'
    $('td.qr_white').each ->
      $(this).removeClass 'crazy_shape'
    $('td.qr_white_clicked').each ->
      $(this).removeClass 'crazy_shape'
  $('#style_jeweled').click ->
    clearQrStyles()
    $('td.qr_black').each ->
      $(this).addClass 'jeweled'
    $('td.qr_black_clicked').each ->
      $(this).addClass 'jeweled'
    $('td.qr_white').each ->
      $(this).addClass 'jeweled'
    $('td.qr_white_clicked').each ->
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


# Basic logic to exclude known sensitive areas of the QR code.
# # There are cells that could be altered in the area I'm excluding, but
# # the effort to determine safe from unsafe is significantly higher.
# # Excluding the top-most 7 rows and the left-most 7 rows ensures the
# # timing code, versioning, and alignment patterns do not get altered.
protectedCell = (row, col) ->
  if $('"#qr_container td#'+col+'_'+row+'"').exists() and row > 7 and col > 7
    return true
  else
    return false

updateCount = (value) ->
    $('#total_cell_count').html(data_cells)
    $('#altered_cell_count').html(altered_cells)


addCellClicks = ->
  $('#qr_container td').click (e) ->
    #$('#ecc_level').html(30-((altered_cells/data_cells)*100))
    #text = $('#ecc_level').html
    #$('#ecc_level').html(text.substring(0,4))

    cell = $(this)
    coords = cell.attr('id').split('_')
    if protectedCell(coords[1], coords[0]) == true 
      if altered_cells < Math.floor(data_cells * ecc)
        if $(this).hasClass 'clicked'
          altered_cells = altered_cells - 1
        else
          altered_cells = altered_cells + 1
        updateCount(altered_cells)
        cell.toggleClass 'clicked'

        if cell.hasClass 'clicked'
          if cell.hasClass 'qr_black'
            cell.addClass 'qr_white_clicked'
            cell.removeClass 'qr_black'
          if cell.hasClass 'qr_white'
            cell.addClass 'qr_black_clicked'
            cell.removeClass 'qr_white'
        else
          if cell.hasClass 'qr_black_clicked'
            cell.addClass 'qr_white'
            cell.removeClass 'qr_black_clicked'
          if cell.hasClass 'qr_white_clicked'
            cell.addClass 'qr_black'
            cell.removeClass 'qr_white_clicked'

# Just learning how CoffeeScript works and keeping this here for my personal archival value, I realize this is a bit wonky.
generate =
  code: (content) ->
    $.post 'code.html',
           content: $('#qr_content').val()
           (data) ->
             console.log('qr post success')
             $('#qr_container').html(data)
             addCellClicks()
             data_cells = $('#qr_container td').size()
