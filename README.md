## About

This is a wordsearch game I made with AngularJS. I originally made it for the [Professor P website](http://professorp.co.uk/games/wordsearch/). 

It has also been adapted for the language learning site [Internet Polyglot](http://www.internetpolyglot.com/). See [here](http://www.internetpolyglot.com/word_search_game?lessonId=-2104301155) and [here](http://www.internetpolyglot.com/word_search_game?lessonId=-4602101160) for examples.

The original source code can be found [here](https://github.com/davidxmoody/professorp.co.uk). This repository extracts the source code from the rest of the Professor P website and introduces a new webpack build script. It can also be run standalone in an iframe:

```html
<iframe src="https://davidxmoody.com/wordsearch/" style="width: 600px; height: 410px"></iframe>
```

You can customise the words to display as well as the size of the grid and maximum number of words to place in the grid by adding options to the query string. For example:

```html
<iframe src="https://davidxmoody.com/wordsearch/?width=9&height=9&maxWords=20&word=these&word=will&word=be&word=the&word=words&word=you&word=find" style="width: 600px; height: 410px"></iframe>
```

You may need to play around with the styling of the iframe to fit everything in depending on the context it is in. Also, please do not remove the "Made by davidxmoody" string at the bottom.

Please feel free to give me any feedback or suggestions at <david@davidxmoody.com>
