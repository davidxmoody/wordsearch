---
browserify: true
---

angular = require 'angular'
_ = require 'underscore'
defaultWordlist = require './wordlist'

# Number of available color classes defined in the Sass file
# Note that this must manually be kept up to date
NUM_COLORS = 5

# "Common" letters are more likely to occur than "uncommon" ones
ALPHABET = 'AABBCCDDEEFFGGHHIIJKLLMMNNOOPPQRSSTTUUVWXYZ'

# Directions words can be placed along, shuffled to avoid repeating patterns
DIRECTIONS = _.shuffle([ [1, 0], [0, 1], [-1, 0], [0, -1],
                         [1, 1], [1, -1], [-1, 1], [-1, -1] ])

# Helper function to join the letters from a path to form its word
wordFromPath = (path) ->
  word = ''
  if path?
    for cell in path
      word += cell.letter
  word


class Cell
  constructor: (@x, @y) ->
    @solvedColorClasses = []
    @isSelected = false
    @onPath = false
    @onCorrectPath = false

  willFitLetter: (letter) ->
    not @letter? or @letter is letter

  randomFill: ->
    @letter = _.sample(ALPHABET) unless @letter?


class LetterGrid
  constructor: (@width=8, @height=8, maxWords=20, wordlist=defaultWordlist) ->
    # Make an empty grid.
    @cells = (new Cell(x, y) for x in [0..@width-1] for y in [0..@height-1])
    @words = []

    # Shuffle the wordlist and then sort by word length. This prevents the
    # first fittable word from always appearing in the grid.
    wordlist = _.sortBy(_.shuffle(wordlist), (word) -> -1*word.length)

    # Start at the beginning of the wordlist (which should be sorted by 
    # descending word length) and try to fit in each word until one has been
    # successfully fitted. Once a word has been fit into the grid, start over
    # at the beginning of the wordlist again. This should emphasize words
    # nearer the start of the wordlist (i.e. longer words). Repeat maxWords
    # times.
    for i in [1..maxWords]
      for word in wordlist
        if word not in @words
          break if @_tryPutWord(word)

    # Fill in all unfilled cells with random letters.
    for row in @cells
      for cell in row
        cell.randomFill()

    # Sort words by length (because it is generally easier for the player to 
    # find longer words first and showing them at the top of the list makes
    # that easier).
    @words = _.sortBy(@words, (word) -> -1*word.length)


  _tryPutWord: (word) ->
    # Choose a random path which will definitely fit into the grid
    [dirX, dirY] = DIRECTIONS[@words.length%DIRECTIONS.length]
    return false if dirX isnt 0 and word.length>@width or dirY isnt 0 and word.length>@height

    # Choose random start and end points such that the word will never have to
    # overlap the edges of the grid.
    startX = _.random((if dirX is -1 then word.length-1 else 0), (if dirX is 1 then @width-word.length else @width-1))
    startY = _.random((if dirY is -1 then word.length-1 else 0), (if dirY is 1 then @height-word.length else @height-1))
    endX = startX+dirX*(word.length-1)
    endY = startY+dirY*(word.length-1)

    path = @_getPath([startX, startY], [endX, endY])

    # Return if any cell is already filled with a conflicting letter
    for cell, i in path
      return false unless cell.willFitLetter(word[i])

    # Set the new word
    for cell, i in path
      cell.letter = word[i]
    @words.push(word)
    return true


  _getPath: (start, end) ->
    #TODO can this be tidied up a bit?
    [x, y] = start
    [endX, endY] = end

    diffX = endX - x
    diffY = endY - y

    stepX = if diffX==0 then 0 else diffX/Math.abs(diffX)
    stepY = if diffY==0 then 0 else diffY/Math.abs(diffY)

    cellList = []

    while x>=0 and y>=0 and x<@width and y<@height
      cellList.push(@cells[y][x])
      if x is endX and y is endY
        return cellList
      x += stepX
      y += stepY

    return null

  getPathFromCells: (start, end) ->
    @_getPath([start.x, start.y], [end.x, end.y])



angular.module('wordsearchApp', []).controller 'WordsearchCtrl', ['$scope', ($scope) ->

  $scope.levels = [
    { width: 8, height: 8 }
    { width: 9, height: 9 }
    { width: 10, height: 10 }
    { width: 11, height: 11 }
  ]

  $scope.loadLevel = (level) ->
    $scope.currentLevel = level
    $scope.grid = new LetterGrid(level.width, level.height)
    $scope.words = $scope.grid.words
    $scope.foundWords = []

    $scope.enableInput = true
    $scope.colorIndex = 1
    $scope.colorClass = 'color1'

  $scope.loadLevel($scope.levels[0])


  $scope.cellClicked = (cell) ->
    return unless $scope.enableInput
    if not $scope.selectedCell?
      cell.isSelected = true
      $scope.selectedCell = cell
    else
      path = $scope.grid.getPathFromCells($scope.selectedCell, cell)
      $scope.selectedCell.isSelected = false
      $scope.selectedCell = null
      $scope._submitPath(path)
      $scope.clearPath()


  $scope.updatePath = (cell) ->
    if $scope.selectedCell?
      path = $scope.grid.getPathFromCells($scope.selectedCell, cell)
      if path?
        for cell in path
          cell.onPath = true
          if wordFromPath(path) in $scope.words
            cell.onCorrectPath = true


  $scope.clearPath = ->
    for row in $scope.grid.cells
      for cell in row
        cell.onPath = false
        cell.onCorrectPath = false


  $scope._submitPath = (path) ->
    foundWord = wordFromPath(path)
    if foundWord in $scope.words
      $scope.words.splice($scope.words.indexOf(foundWord), 1)
      $scope.foundWords.unshift({ word: foundWord, colorClass: $scope.colorClass })
      for cell in path
        cell.solvedColorClasses.push($scope.colorClass)
      $scope.nextColor()

      if $scope.words.length is 0
        $scope.enableInput = false
        alertCongrats = ->
          alert("Congratulations, you found all #{$scope.foundWords.length} words! Select a new difficulty level from the menu to play again.")
        setTimeout(alertCongrats, 400)  # The delay allows the wordlist crossout to be updated


  $scope.nextColor = ->
    $scope.colorIndex = $scope.colorIndex%NUM_COLORS+1
    $scope.colorClass = "color#{$scope.colorIndex}"
]
