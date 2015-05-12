require './style.scss'

angular = require 'angular'
require 'ng-dialog/css/ngDialog.css'
require 'ng-dialog/css/ngDialog-theme-default.css'
require 'ng-dialog'

_ = require 'underscore'

howToPlayHTML = require './how-to-play.html'
LetterGrid = require "./letter-grid"

# Number of available color classes defined in the Sass file
# Note that this must manually be kept up to date
NUM_COLORS = 5

# Helper function to join the letters from a path to form its word
wordFromPath = (path) ->
  word = ''
  if path?
    for cell in path
      word += cell.letter
  word


angular.module('wordsearchApp', ['ngDialog']).controller 'WordsearchCtrl', ['$scope', 'ngDialog', ($scope, ngDialog) ->

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
      console.log('hello world')
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

  # Show intro dialog
  ngDialog.open(
    template: howToPlayHTML
    plain: true
  )
]
