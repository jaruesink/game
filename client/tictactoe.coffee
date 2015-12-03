#set up the cells
initiate_cells = ->
  cells = {}
  i = 1
  while i < 10
    cells['cell' + i] = ((n) ->
      ->
        Session.get 'cell' + n
    )(i)
    i++
  return cells

Template.tictactoe.helpers do initiate_cells

$ ->
  $game       = $ '#tictactoe', 'main'
  $cell       = $ 'td', '#tictactoe'
  $new_game   = $ '#new_game', '#tictactoe'
  moveNumber  = 0
  gridSize    = $('tr').length
  cellCount   = gridSize*gridSize
  cellGrid    = Array(cellCount)

  createCellGrid = ->
    i = 0
    while i < cellCount
      cellGrid[i] = [i%gridSize, Math.floor(i/gridSize)]
      i++
  do createCellGrid

  isOdd = (num) ->
    num % 2



  game_on = ->
    $game.attr 'data-active', true
    $game.data 'active', true
    set_turn 'ex'
    moveNumber = 0
  game_over = ->
    $game.attr 'data-active', false
    $game.data 'active', false
  place = (ex_or_oh, cellNumber) ->
    Session.set 'cell'+cellNumber, ex_or_oh
  clear_board = ->
    unset_played $cell
    do game_on
    cellNumber = 1
    while cellNumber < 10
      place null, cellNumber
      cellNumber++
  set_turn = (ex_or_oh) ->
    $game.attr 'data-turn', ex_or_oh
    $game.data 'turn', ex_or_oh
  switch_turn = ->
    console.log 'switching the turn from '+$game.data 'turn'
    if $game.data('turn') is 'ex' 
      set_turn 'oh'
    else 
      set_turn 'ex'
  set_played = (cells) ->
    cells.attr 'data-played', true
    cells.data 'played', true
  unset_played = (cells) ->
    cells.attr 'data-played', false
    cells.data 'played', false

  do game_on

  $cell.click ->
    console.log do $(this).data
    unless $(this).data 'played'
      thisCellNumber = $(this).data('cellNumber')
      if $game.data('turn') is 'ex'
        place 'ex', thisCellNumber
        console.log 'ex played in cell '+thisCellNumber
      else
        place 'oh', thisCellNumber
        console.log 'oh played in cell '+thisCellNumber
      set_played $(this)

      if moveNumber < 8
        moveNumber++
        do switch_turn
        console.log 'it is now '+$game.data('turn')+'\'s turn'
      else
        console.log 'the game is over'
        do game_over

  $new_game.click ->
    do clear_board
