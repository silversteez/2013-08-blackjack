class window.Hand extends Backbone.Collection

  model: Card

  initialize: (array, @deck, @isDealer) ->

  checkBlackJack: -> #checks for player Black Jack after deal
    @bestScore() == 21

  hit: ->
    @add(@deck.pop()).last()

    if !@isDealer
      @trigger 'playerBust', this if @scores()[0] > 21
      @trigger '21', this if @scores()[0] == 21 or @scores()[1] == 21

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    hasAce = @reduce (memo, card) ->
      memo or card.get('value') is 1
    , false
    score = @reduce (score, card) ->
      score + if card.get 'revealed' then card.get 'value' else 0
    , 0
    if hasAce then [score, score + 10] else [score]

  bestScore: ->
    scores = @scores()
    if scores[1] and scores[1] > scores[0] and scores[1] <= 21
      return scores[1]
    else return scores[0]

  dealerTurn: (playerHasBlackJack) ->
    @at(0).flip()

    if playerHasBlackJack
      if @scores()[1] == 21
        @trigger 'tieBlackJack', this
      else @trigger 'playerBlackJack', this

    else if @scores()[1] == 21
      @trigger 'dealerBlackJack', this

    else @delayedHit()

  delayedHit: =>
    #base logic on optimum hand score
    score = @bestScore()

    if score < 17
      setTimeout =>
        @hit()
        @delayedHit()
      , 600
    else if score > 21
      @trigger 'dealerBust', this
    else if score == 21
      @trigger 'dealer21', this
    else
      @trigger 'compareHands', this

