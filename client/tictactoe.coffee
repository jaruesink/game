#set up the cells
Template.tictactoe.helpers
  cell1: ->
    Session.get 'cell1'
  cell2: ->
    Session.get 'cell2'
  cell3: ->
    Session.get 'cell3'
  cell4: ->
    Session.get 'cell4'
  cell5: ->
    Session.get 'cell5'
  cell6: ->
    Session.get 'cell6'
  cell7: ->
    Session.get 'cell7'
  cell8: ->
    Session.get 'cell8'
  cell9: ->
    Session.get 'cell9'

$ ->
  $game       = $ '#tictactoe', 'main'
  $cell       = $ 'td', '#tictactoe'
  $new_game   = $ '#new_game', '#tictactoe'
  moveNumber = 0

  isOdd = (num) ->
    num % 2
  place = (ex_or_oh, cellNumber) ->
    Session.set 'cell'+cellNumber, ex_or_oh
  initialize_game = ->
    do game_on
    set_turn 'ex'
    moveNumber = 0
  clear_board = ->
    unset_played $cell
    moveNumber = 0
    do initialize_game
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
  game_on = ->
    $game.attr 'data-active', true
    $game.data 'active', true
  game_over = ->
    $game.attr 'data-active', false
    $game.data 'active', false

  do initialize_game

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
