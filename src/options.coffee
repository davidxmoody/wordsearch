queryString = require "query-string"
defaultWordlist = require "./default-wordlist"

options = queryString.parse(window.location.search)

options.wordlist = (options.word ? defaultWordlist).map (word) -> word.toUpperCase()
options.height = if options.height then parseInt(options.height) else 8
options.width = if options.width then parseInt(options.width) else 8
options.maxWords = if options.maxWords then parseInt(options.maxWords) else 8

module.exports = options
