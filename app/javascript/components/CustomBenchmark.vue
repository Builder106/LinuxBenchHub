<template>
   <div class="container">
     <h1>Submit Custom Benchmark</h1>
     <form @submit.prevent="submitBenchmark">
       <div class="form-group">
         <label for="name">Benchmark Name</label>
         <input type="text" id="name" class="form-control" v-model="name" />
       </div>
       <div class="form-group">
         <label for="description">Description</label>
         <textarea id="description" class="form-control" v-model="description"></textarea>
       </div>
       <div class="form-group">
         <label for="configuration">Configuration</label>
         <textarea id="configuration" class="form-control" v-model="configuration"></textarea>
       </div>
       <div class="form-group">
         <button type="submit" class="btn btn-primary">Submit</button>
       </div>
     </form>
   </div>
 </template>
 
 <script>
 export default {
   data() {
     return {
       name: '',
       description: '',
       configuration: '',
     };
   },
   methods: {
     submitBenchmark() {
       // Handle benchmark submission logic here
     },
   },
 };
 </script>