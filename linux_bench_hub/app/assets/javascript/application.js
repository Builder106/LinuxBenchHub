// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// Import Bootstrap
import "bootstrap"

// Import Stimulus controllers
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

document.addEventListener('DOMContentLoaded', () => {
   const form = document.querySelector('.needs-validation');
   form.addEventListener('submit', (event) => {
     const checkboxes = form.querySelectorAll('input[type="checkbox"][name="performance_benchmark[benchmarks][]"]');
     const isChecked = Array.from(checkboxes).some(checkbox => checkbox.checked);
     
     if (!isChecked) {
       event.preventDefault();
       event.stopPropagation();
       alert('Please select at least one benchmark.');
     }
     
     form.classList.add('was-validated');
   }, false);
 });