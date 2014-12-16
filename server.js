var express = require('express');
var app = express();

var highscores = { 'Me': 1010 };

app.use(express.static(__dirname + '/build'));

app.get('/highscores', function(req, res) {
  res.send(JSON.stringify(highscores));
});

app.get('/highscores/:score', function(req, res) {
  highscores['You'] = req.params.score;
});

var server = app.listen(3000);
