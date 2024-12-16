<template>
   <div class="container mx-auto p-4">
     <h1 class="text-2xl font-bold mb-4">Submit Custom Benchmark</h1>
     <form @submit.prevent="submitBenchmark" class="space-y-4">
       <div class="form-group">
         <label for="name" class="block text-sm font-medium text-gray-700">Benchmark Name</label>
         <input type="text" id="name" class="form-control mt-1 block w-full" v-model="name" />
       </div>
       <div class="form-group">
         <label for="description" class="block text-sm font-medium text-gray-700">Description</label>
         <textarea id="description" class="form-control mt-1 block w-full" v-model="description"></textarea>
       </div>
       <div class="form-group">
         <label for="configuration" class="block text-sm font-medium text-gray-700">Configuration</label>
         <textarea id="configuration" class="form-control mt-1 block w-full" v-model="configuration"></textarea>
       </div>
       <div class="form-group">
         <button type="submit" class="btn btn-primary bg-blue-500 text-white px-4 py-2 rounded">Submit</button>
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