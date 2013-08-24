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
    #currently replaces the old deck with a fresh deck and hands for each new game
    @set 'deck', deck = new Deck()
    @set 'playerHand', playerHand = deck.dealPlayer()
    @set 'dealerHand', dealerHand = deck.dealDealer()
    playerHand.on 'playerBust', => @playerBust()
    playerHand.on '21', => @player21()
    dealerHand.on 'tieBlackJack', => @tieBlackJack()
    dealerHand.on 'playerBlackJack', => @playerBlackJack()
    dealerHand.on 'dealerBlackJack', => @dealerBlackJack()
    dealerHand.on 'dealerBust', => @dealerBust()
    dealerHand.on 'dealer21', => @dealer21()
    dealerHand.on 'compareHands', => @compareHands()

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
      @dealerTurn("playerHasBlackJack")

  compareHands: ->
    dealerScore = @get('dealerHand').scores()[0]
    playerScore = @get('playerHand').scores()[0]

    if dealerScore == playerScore then @tieGame()
    else if dealerScore > playerScore then @dealerWin()
    else @playerWin()

  playerBust: ->
    @set 'isPlayerTurn', false
    @set 'notification', "BUSTED!"
    @endGame()

  player21: ->
    @set 'isPlayerTurn', false
    @set 'notification', "21! A winner is YOU!"
    @endGame()

  playerBlackJack: -> #called by dealer hand if player has BJ and dealer does not
    @set 'notification', "WOOHOO! BLACK JACK, BABY!!!"
    @endGame()

  dealerTurn: (playerHasBlackJack) ->
    console.log playerHasBlackJack
    @set 'isPlayerTurn', false
    @set 'notification', "NOW IT'S MY TURN!!!"
    @trigger('startDealerTurn') #re-renders to disable the player's buttons
    @get('dealerHand').dealerTurn(playerHasBlackJack)

  tieBlackJack: ->
    @set 'notification', "We BOTH got Black Jack!? NUTS!!!"
    @endGame()

  dealerBlackJack: ->
    @set 'notification', "BLACK JACK, BITCH! YOU LOSE!"
    @endGame()

  dealer21: ->
    @set 'notification', "WHOA! I gots 21. You lose."
    @endGame()

  dealerBust: ->
    @set 'notification', "I DONE BUSTED! You win..."
    @endGame()

  tieGame: ->
    @set 'notification', "WTF, a tie?"
    @endGame()

  playerWin: ->
    @set 'notification', "Aw, shucks! You won!"
    @endGame()

  dealerWin: ->
    @set 'notification', "You lose, loser!"
    @endGame()


