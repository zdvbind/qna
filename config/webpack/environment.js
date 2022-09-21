const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
const handlebars = require('./loaders/handlebars')

environment.plugins.prepend('Provide', new webpack.ProvidePlugin({
  $: 'jquery/src/jquery',
  jQuery: 'jquery/src/jquery',
  Popper: ['popper.js', 'default']
}))

environment.loaders.prepend('handlebars', handlebars)

module.exports = environment
