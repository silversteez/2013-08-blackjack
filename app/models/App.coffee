#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @newDeckAndHands()
    @set 'isPlayerTurn', true
    @set 'isEndGame', false
    @set 'notification', "Let's Play BLACK JACK, baby!!!"
    #only checking for Black Jack on the initial deal
    @checkBlackJack()

  newDeckAndHands: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', playerHand = deck.dealPlayer()
    @set 'dealerHand', dealerHand = deck.dealDealer()
    playerHand.on 'playerBust', => @playerBust()
    playerHand.on '21', => @player21()
    dealerHand.on 'dealerBlackJack', => @dealerBlackJack()

  endGame: ->
    @set 'isEndGame', true
    @trigger('endGame')

  newGame: ->
    @set 'notification', "Have fun and good luck!"
    @set 'isPlayerTurn', true
    @set 'isEndGame', false
    @newDeckAndHands()
    @trigger('startNewGame')

  checkBlackJack: ->
    if @get('playerHand').checkBlackJack()
      @set 'isPlayerTurn', false
      @set 'notification', "BLACK JACK! WOOOHOOO!!!"
      @endGame()

  playerBust: ->
    @set 'isPlayerTurn', false
    @set 'notification', "BUSTED!"
    @endGame()

  player21: ->
    @set 'isPlayerTurn', false
    @set 'notification', "21! A winner is YOU!"
    @endGame()

  dealerTurn: ->
    @set 'isPlayerTurn', false
    @set 'notification', "NOW IT'S MY TURN!!!"
    @trigger('startDealerTurn') #re-renders to disable the player's buttons
    @get('dealerHand').dealerTurn()

  dealerBlackJack: ->
    @set 'isEndGame', true
    @set 'notification', "BLACK JACK, BITCH! YOU LOSE!"
    @endGame()

