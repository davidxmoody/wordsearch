var koa = require('koa');
var serve = require('koa-static');
var route = require('koa-route');
var app = koa();

var highscores = { 'Me': 1010 };

app.use(serve('build'));

app.use(route.get('/highscores', function *() {
  this.body = JSON.stringify(highscores);
}));

app.use(route.get('/highscores/:score', function *(score) {
  highscores['You'] = score;
  this.body = "High score submitted, thank you.";
}));

app.listen(3000);
