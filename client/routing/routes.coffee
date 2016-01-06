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