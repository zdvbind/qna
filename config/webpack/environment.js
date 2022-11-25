const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
const handlebars = require('./loaders/handlebars')

environment.plugins.prepend('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  Popper: ['popper.js', 'default']
}))

environment.loaders.prepend('handlebars', handlebars)
environment.config.set('resolve.alias', {jquery: 'jquery/src/jquery'});  // <--- this additional line!

module.exports = environment
