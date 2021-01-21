const { environment } = require('@rails/webpacker')

// ここから
// jQueryとBootstapのJSを使えるように
const webpack = require('webpack')
environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery/src/jquery',
  jQuery: 'jquery/src/jquery',
  Popper: ['popper.js', 'default']
  }))
// ここまで

module.exports = environment
