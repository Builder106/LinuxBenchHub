// config/webpack/environment.js
const { environment } = require('@rails/webpacker');
const vue = require('./loaders/vue');

environment.loaders.prepend('vue', vue);
environment.plugins.prepend('VueLoaderPlugin', new (require('vue-loader').VueLoaderPlugin)());

module.exports = environment;