#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @newDeckAndHands()
    @set 'isPlayerTurn', true
    @set 'isEndGame', false
    @set 'notification', "Let's Play BLACK JACK, baby!!!"

  newDeckAndHands: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', playerHand = deck.dealPlayer()
    @set 'dealerHand', dealerHand = deck.dealDealer()
    playerHand.on 'playerBust', => @playerBust()

  endGame: ->
    @trigger('endGame')

  newGame: ->
    @set 'notification', "Have fun and good luck!"
    @set 'isPlayerTurn', true
    @newDeckAndHands()
    @trigger('startNewGame')

  playerBust: ->
    @set 'isPlayerTurn', false
    @set 'notification', "BUSTED!"
    @endGame()

  dealerTurn: ->
    @set 'isPlayerTurn', false
    @trigger('startDealerTurn')

