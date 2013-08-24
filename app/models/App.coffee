#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @newDeckAndHands()
    @set 'isPlayerTurn', true

  newDeckAndHands: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()

  dealerTurn: ->
    console.log "dealerTurn!"

    @set 'isPlayerTurn', false
    @trigger('startDealerTurn')

  endGame: ->
    @trigger('endGame')

  newGame: ->
    @set 'isPlayerTurn', true
    @newDeckAndHands()
    @trigger('startNewGame')

