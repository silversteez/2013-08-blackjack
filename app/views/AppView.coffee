class window.AppView extends Backbone.View

  template: _.template '
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button>
    <button class="new-game-button hidden">Start New Game!</button>
    <div class="notifications"><%- notification %></div>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  events:
    "click .hit-button": -> @model.get('playerHand').hit()
    "click .stand-button": -> @model.dealerTurn()
    "click .new-game-button": -> @model.newGame()

  initialize: ->
    @render()
    @model.on 'startDealerTurn', => @render() #re-render, disabling buttons
    @model.on 'startNewGame', => @render()
    @model.on 'endGame', => @render()

  render: ->
    console.log "rendering appView"
    @$el.children().detach()
    @$el.html @template(this.model.attributes)

    @$('.hit-button').attr('disabled', 'true') if !this.model.get 'isPlayerTurn'
    @$('.stand-button').attr('disabled', 'true') if !this.model.get 'isPlayerTurn'

    @$('.new-game-button').removeClass('hidden') if this.model.get 'isEndGame'

    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el

