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
  checked_positions = new Array

  createCellGrid = ->
    i = 0
    while i < cellCount
      cellGrid[i] = [i%gridSize, Math.floor(i/gridSize)]
      i++

  class Cell
    constructor: (@cellNumber, @ex_or_oh) ->

    check_for_win: ->
      x         = cellGrid[@cellNumber-1][0]
      y         = cellGrid[@cellNumber-1][1]
      played    = cellGrid[@cellNumber-1][2]
      positions = surrounding_positions x, y
      findLeadingConsecutive @cellNumber, @ex_or_oh

  getCellNumber = (x, y) ->
    if y is 0 then x+1 else x%gridSize+gridSize*y+1
    
  getCoordinates = (cellNumber) ->
    cellGrid[cellNumber-1]

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

  findLeadingConsecutive = (cellNumber, played) ->
    checked_positions = []
    coordinates = getCoordinates cellNumber
    x = coordinates[0]
    y = coordinates[1]
    positions = surrounding_positions x, y
    surrounding_locations = new Array
    for position in positions
      surrounding_x = position[0]
      surrounding_y = position[1]
      surrounding_number = null
      if surrounding_x > -1 and surrounding_y > -1 and surrounding_x < cellCount/gridSize and surrounding_y < cellCount/gridSize
        surrounding_number = getCellNumber surrounding_x, surrounding_y
        surrounding_played = cellGrid[surrounding_number-1][2]
        if surrounding_number and surrounding_played is played
          surrounding_location = position[2]
          checked_positions.push surrounding_number
          break
        else
          surrounding_number = null
    console.log 'surrounding_number', surrounding_number
    console.log 'checked_positions', checked_positions
    # surrounding_number needs to be the next surrounding number position
    if surrounding_number and checked_positions.indexOf(surrounding_number) < 0
      findLeadingConsecutive surrounding_number, played
      console.log 'leading consecutive is', surrounding_number

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
      thisCell = new Cell cellNumber, ex_or_oh
      console.log getCoordinates cellNumber
      do thisCell.check_for_win

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
