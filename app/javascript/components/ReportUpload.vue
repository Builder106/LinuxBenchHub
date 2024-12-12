<template>
   <div class="container">
     <h1>Upload Benchmarking Data</h1>
     <form @submit.prevent="uploadData">
       <div class="form-group">
         <label for="dataFile">Benchmarking Data File</label>
         <input type="file" id="dataFile" class="form-control" @change="handleFileUpload" />
       </div>
       <div class="form-group">
         <button type="submit" class="btn btn-primary">Upload</button>
       </div>
     </form>
     <div v-if="notification" class="alert alert-info">
       Report generation in progress...
     </div>
   </div>
 </template>
 
 <script>
 export default {
   data() {
     return {
       dataFile: null,
       notification: false,
     };
   },
   methods: {
     handleFileUpload(event) {
       this.dataFile = event.target.files[0];
     },
     uploadData() {
       this.notification = true;
       // Handle file upload logic here
     },
   },
 };
 </script>