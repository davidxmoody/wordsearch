_ = require "underscore"
defaultWordlist = require "./default-wordlist"
Cell = require "./cell"

# Directions words can be placed along, shuffled to avoid repeating patterns
DIRECTIONS = _.shuffle([ [1, 0], [0, 1], [-1, 0], [0, -1],
                         [1, 1], [1, -1], [-1, 1], [-1, -1] ])

module.exports = class LetterGrid
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
