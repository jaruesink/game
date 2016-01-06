FlowRouter.triggers.enter [AccountsTemplates.ensureSignedIn]

FlowRouter.route '/',
    action: ->
      BlazeLayout.render 'wrapper',
        main: 'home'

FlowRouter.route '/tictactoe',
    action: ->
      BlazeLayout.render 'wrapper',
        main: 'game'
        game: 'tictactoe'

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

      # I need to figure out how to get tictactoe.coffee to run after this runs instead of on dom loaded

# Account Routes
AccountsTemplates.configureRoute 'changePwd'
AccountsTemplates.configureRoute 'forgotPwd'
AccountsTemplates.configureRoute 'resetPwd'
AccountsTemplates.configureRoute 'signIn'
AccountsTemplates.configureRoute 'signUp'
AccountsTemplates.configureRoute 'verifyEmail'

signOut = ->
  FlowRouter.go('/sign-in')

AccountsTemplates.configure
  onLogoutHook: signOut