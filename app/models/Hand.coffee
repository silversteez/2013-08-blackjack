class window.Hand extends Backbone.Collection

  model: Card

  initialize: (array, @deck, @isDealer) ->

  checkBlackJack: -> @scores()[1] == 21

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

  dealerTurn: ->
    @at(0).flip()
    return @trigger 'dealerBlackJack', this if @scores()[1] == 21
    @delayedHit()

  delayedHit: =>
    if @scores()[0] < 17
      setTimeout =>
        @hit()
        @delayedHit()
      , 600


