# #set up the cells
# initiate_cells = ->
#   cells = {}
#   i = 1
#   while i <= 9
#     cells['cell' + i] = ((n) ->
#       ->
#         Session.get 'cell' + n
#     )(i)
#     i++
#   return cells
  
# Template.tictactoe.helpers do initiate_cells

# $ ->
#   $game       = $ '#tictactoe', 'main'
#   $cell       = $ 'td', '#tictactoe'
#   $new_game   = $ '#new_game', '#tictactoe'
#   moveNumber  = 0
#   gridSize    = $('tr').length
#   cellCount   = gridSize*gridSize
#   cellGrid    = Array(cellCount)
#   consecutive_plays = new Array

#   createCellGrid = ->
#     i = 0
#     while i < cellCount
#       cellGrid[i] = [i%gridSize, Math.floor(i/gridSize)]
#       i++

#   class Cell
#     constructor: (@cellNumber, @ex_or_oh) ->

#     check_for_win: ->
#       x           = cellGrid[@cellNumber-1][0]
#       y           = cellGrid[@cellNumber-1][1]
#       played      = cellGrid[@cellNumber-1][2]
#       positions   = getSurroundingPositions x, y
#       consecutive = findConsecutivePlays @cellNumber, @ex_or_oh
#       win         = checkWin @cellNumber, consecutive, @ex_or_oh
#       if win
#         win.push @cellNumber
#         for winner in win
#           $cell.eq(winner-1).addClass 'winning'
#         $game.attr('data-winner', @ex_or_oh)
#         do game_over
#         console.log 'winning_numbers', win
        

#   getCellNumber = (x, y) ->
#     if y is 0 then x+1 else x%gridSize+gridSize*y+1
    
#   getCoordinates = (cellNumber) ->
#     cellGrid[cellNumber-1]

#   getSurroundingPositions = (x, y) ->
#     positions = [
#                   [x-1, y-1, 'top-left'],
#                   [x  , y-1, 'top'],
#                   [x+1, y-1, 'top-right'],
#                   [x-1, y  , 'left'],
#                   [x+1, y+1, 'bottom-right'],
#                   [x  , y+1, 'bottom'],
#                   [x-1, y+1, 'bottom-left'],
#                   [x+1, y  , 'right']
#                 ]

#   findConsecutivePlays = (cellNumber, played) ->
#     consecutive_plays = []
#     coordinates = getCoordinates cellNumber
#     x = coordinates[0]
#     y = coordinates[1]
#     positions = getSurroundingPositions x, y
#     for position in positions
#       surrounding_x = position[0]
#       surrounding_y = position[1]
#       position_name = position[2]
#       if surrounding_x > -1 and surrounding_y > -1 and surrounding_x < cellCount/gridSize and surrounding_y < cellCount/gridSize
#         surrounding_number = getCellNumber surrounding_x, surrounding_y
#         surrounding_played = cellGrid[surrounding_number-1][2]
#         if surrounding_played is played
#           consecutive_plays.push [surrounding_number, position_name]
#     if consecutive_plays.length > 0 then return consecutive_plays else false
    
#   checkWin = (origin, consecutive, played) ->
#     win = false
#     winning_numbers = new Array
#     position_names  = new Array
#     origin_coordinates = getCoordinates origin
#     origin_x           = origin_coordinates[0]
#     origin_y           = origin_coordinates[1]
#     origin_positions   = getSurroundingPositions origin_x, origin_y

#     for consecutive_play in consecutive
#       consecutive_number      = consecutive_play[0]
#       consecutive_name        = consecutive_play[1]
#       consecutive_coordinates = getCoordinates consecutive_number
#       consecutive_x           = consecutive_coordinates[0]
#       consecutive_y           = consecutive_coordinates[1]
#       consecutive_positions   = getSurroundingPositions consecutive_x, consecutive_y
#       position_names.push consecutive_name

#       # Check for winning position when all in a row.
#       next_consecutives = findConsecutivePlays consecutive_number, played
#       for next_consecutive in next_consecutives
#         next_consecutive_name = next_consecutive[1]
#         if consecutive_name is next_consecutive_name
#           winning_numbers.push next_consecutive[0]
#           winning_numbers.push consecutive_number
#           win = winning_numbers
#         if win
#           break
#       if win
#         break

#     unless win

#       # Check for winning position if middle row is played last.
#       if position_names.length > 1
#         for position_name in position_names
#           current_position_name  = position_name
#           current_position_index = false
#           current_position_x     = false
#           current_position_y     = false
#           next_position_index    = false
#           for position, index in origin_positions
#             if position[2] is current_position_name
#               current_position_x     = position[0]
#               current_position_y     = position[1]
#               current_position_index = index
#           for position_name in position_names
#             for position, index in origin_positions
#               if position[2] is position_name
#                 next_position_index = index
#             if Math.abs(current_position_index - next_position_index) is 4
#               winning_numbers.push getCellNumber current_position_x, current_position_y
#               winning_numbers.push consecutive_number
#               win = winning_numbers
#             if win
#               break
#           if win
#             break

#     return win

#   game_on = ->
#     $game.attr 'data-active', true
#     $game.data 'active', true
#     set_turn 'ex'
#     moveNumber = 0
#     do createCellGrid
#     console.log 'starting a new game'

#   game_over = ->
#     $game.attr 'data-active', false
#     $game.data 'active', false
#     console.log 'the game is over'

#   place = (ex_or_oh, cellNumber) ->
#     Session.set 'cell'+cellNumber, ex_or_oh
#     if ex_or_oh is 'ex' or ex_or_oh is 'oh'
#       cellGrid[cellNumber-1].push ex_or_oh
#       thisCell = new Cell cellNumber, ex_or_oh
#       console.log getCoordinates cellNumber
#       do thisCell.check_for_win

#   clear_board = ->
#     $game.removeAttr 'data-winner'
#     $cell.removeClass 'winning'
#     unset_played $cell
#     cellGrid = Array(cellCount)
#     cellNumber = 1
#     while cellNumber <= cellCount
#       place null, cellNumber
#       cellNumber++
#     do game_on

#   set_turn = (ex_or_oh) ->
#     $game.attr 'data-turn', ex_or_oh
#     $game.data 'turn', ex_or_oh

#   switch_turn = ->
#     if $game.data('turn') is 'ex' 
#       set_turn 'oh'
#     else 
#       set_turn 'ex'
#     console.log 'it is now '+$game.data('turn')+'\'s turn'

#   set_played = (cells) ->
#     cells.attr 'data-played', true
#     cells.data 'played', true

#   unset_played = (cells) ->
#     cells.attr 'data-played', false
#     cells.data 'played', false

#   do game_on

#   $cell.click ->
#     unless $(this).data('played') or $game.data('active') is false
#       thisCellNumber = $(this).data('cellNumber')
#       if $game.data('turn') is 'ex'
#         place 'ex', thisCellNumber
#       else
#         place 'oh', thisCellNumber
#       set_played $(this)

#       if moveNumber < 8
#         moveNumber++
#         do switch_turn
#       else
#         do game_over

#   $new_game.click ->
#     do clear_board
