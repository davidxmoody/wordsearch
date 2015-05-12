module.exports =
  entry: "./src/main.coffee"
  output:
    path: "./build"
    publicPath: "/"
    filename: "main.js"
  module:
    loaders: [
      { test: /\.coffee$/, loader: "coffee-loader" }
      { test: /\.css$/, loader: "style-loader!css-loader" }
      { test: /\.scss$/, loader: "style-loader!css-loader!sass-loader" }
    ]
  resolve:
    extensions: [
      ""
      ".js"
      ".coffee"
      ".css"
      ".scss"
    ]
