#set up the cells
initiate_cells = ->
  cells = {}
  i = 1
  while i <= 9
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
  what_has_been_played  = new Array

  createCellGrid = ->
    i = 0
    while i < cellCount
      cellGrid[i] = [i%gridSize, Math.floor(i/gridSize)]
      i++

  class Cell
    constructor: (@cellNumber) ->

    getCoordinates: ->
      cellGrid[@cellNumber-1]

    checkSurroundingCells: ->
      x         = cellGrid[@cellNumber-1][0]
      y         = cellGrid[@cellNumber-1][1]
      played    = cellGrid[@cellNumber-1][2]
      positions = surrounding_positions x, y
      what_has_been_played = new Array

      whatIsPlayed position, played for position in positions
      if what_has_been_played.length > 0
        return what_has_been_played
      else
        return false

  getCellNumberFromCoordinates = (x, y) ->
    cellCount*x+y+1

  surrounding_positions = (x, y) ->
    positions = [
                  [x-1, y-1, 'top-left'],
                  [x  , y-1, 'top'],
                  [x+1, y-1, 'top-right'],
                  [x-1, y  , 'left'],
                  [x+1, y  , 'right'],
                  [x-1, y+1, 'bottom-left'],
                  [x  , y+1, 'bottom'],
                  [x+1, y+1, 'bottom-right']
                ]

  whatIsPlayed = (position, played) ->
    x = position[0]
    y = position[1]
    position_name = position[2]

    i = 0
    while i < cellCount
      grid_x      = cellGrid[i][0]
      grid_y      = cellGrid[i][1]
      grid_played = cellGrid[i][2]
      if x is grid_x and y is grid_y and grid_played is played
        what_has_been_played.push "an adjacent "+played+" is played to the "+position_name
      i++

  game_on = ->
    $game.attr 'data-active', true
    $game.data 'active', true
    set_turn 'ex'
    moveNumber = 0
    do createCellGrid
    console.log 'starting a new game'
  game_over = ->
    $game.attr 'data-active', false
    $game.data 'active', false
    console.log 'the game is over'
  place = (ex_or_oh, cellNumber) ->
    Session.set 'cell'+cellNumber, ex_or_oh
    if ex_or_oh is 'ex' or ex_or_oh is 'oh'
      cellGrid[cellNumber-1].push ex_or_oh
      thisCell = new Cell cellNumber
      console.log do thisCell.getCoordinates
      if do thisCell.checkSurroundingCells
        console.log do thisCell.checkSurroundingCells
  clear_board = ->
    unset_played $cell
    cellGrid = Array(cellCount)
    cellNumber = 1
    while cellNumber <= cellCount
      place null, cellNumber
      cellNumber++
    do game_on
  set_turn = (ex_or_oh) ->
    $game.attr 'data-turn', ex_or_oh
    $game.data 'turn', ex_or_oh
  switch_turn = ->
    if $game.data('turn') is 'ex' 
      set_turn 'oh'
    else 
      set_turn 'ex'
    console.log 'it is now '+$game.data('turn')+'\'s turn'
  set_played = (cells) ->
    cells.attr 'data-played', true
    cells.data 'played', true
  unset_played = (cells) ->
    cells.attr 'data-played', false
    cells.data 'played', false

  do game_on

  $cell.click ->
    unless $(this).data 'played'
      thisCellNumber = $(this).data('cellNumber')
      if $game.data('turn') is 'ex'
        place 'ex', thisCellNumber
      else
        place 'oh', thisCellNumber
      set_played $(this)

      if moveNumber < 8
        moveNumber++
        do switch_turn
      else
        do game_over

  $new_game.click ->
    do clear_board
