_ = require "underscore"

# "Common" letters are more likely to occur than "uncommon" ones
ALPHABET = 'AABBCCDDEEFFGGHHIIJKLLMMNNOOPPQRSSTTUUVWXYZ'

module.exports = class Cell
  constructor: (@x, @y) ->
    @solvedColorClasses = []
    @isSelected = false
    @onPath = false
    @onCorrectPath = false

  willFitLetter: (letter) ->
    not @letter? or @letter is letter

  randomFill: ->
    @letter = _.sample(ALPHABET) unless @letter?
