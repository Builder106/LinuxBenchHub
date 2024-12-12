/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

console.log('Hello World from Webpacker')

// Import Bootstrap and jQuery
import 'bootstrap/dist/js/bootstrap'
import 'jquery'

// Import Vue and the HelloWorld component
import { createApp } from 'vue';
import ReportUpload from '../components/ReportUpload.vue';
import ReportLibrary from '../components/ReportLibrary.vue';
import PerformanceComparison from '../components/PerformanceComparison.vue';
import CustomBenchmark from '../components/CustomBenchmark.vue';

document.addEventListener('DOMContentLoaded', () => {
  const app = createApp({});

  app.component('report-upload', ReportUpload);
  app.component('report-library', ReportLibrary);
  app.component('performance-comparison', PerformanceComparison);
  app.component('custom-benchmark', CustomBenchmark);

  app.mount('#app');
});