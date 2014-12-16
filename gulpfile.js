var gulp = require('gulp');
var sass = require('gulp-sass');
var coffee = require('gulp-coffee');

var build_dir = 'build';
var paths = {
  html: 'src/**/*.html',
  css: 'src/**/*.scss',
  js: ['src/**/*.coffee', 'src/**/*.js']
};

gulp.task('default', ['css', 'js', 'html']);

gulp.task('watch', ['default'], function() {
  gulp.watch(paths.html, ['html']);
  gulp.watch(paths.css, ['css']);
  gulp.watch(paths.js, ['js']);
});

gulp.task('html', function() {
  gulp.src(paths.html)
    .pipe(gulp.dest(build_dir));
});

gulp.task('css', function() {
  gulp.src(paths.css)
    .pipe(sass())
    .pipe(gulp.dest(build_dir));
});

gulp.task('js', function() {
  gulp.src(paths.js)
    .pipe(coffee())
    .pipe(gulp.dest(build_dir));
});
