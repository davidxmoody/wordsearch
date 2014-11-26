var gulp = require('gulp');
var sass = require('gulp-sass');
var coffee = require('gulp-coffee');

gulp.task('default', ['css', 'js'], function() {
  gulp.src('src/*.html')
    .pipe(gulp.dest('build'));
});

gulp.task('css', function() {
  gulp.src('src/*.scss')
    .pipe(sass())
    .pipe(gulp.dest('build'));
});

gulp.task('js', function() {
  gulp.src('src/*.coffee')
    .pipe(coffee())
    .pipe(gulp.dest('build'));
});
