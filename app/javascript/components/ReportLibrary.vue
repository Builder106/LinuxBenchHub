<template>
   <div>
     <h1 class="text-2xl font-bold mb-4">Report Library</h1>
     <form @submit.prevent="searchReports" class="space-y-4">
       <div class="form-group">
         <label for="search" class="block text-sm font-medium text-gray-700">Search Reports</label>
         <input type="text" id="search" class="form-control mt-1 block w-full" v-model="searchQuery" placeholder="Search by distribution, metrics, etc." />
       </div>
       <div class="form-group">
         <button type="submit" class="btn btn-primary bg-blue-500 text-white px-4 py-2 rounded">Search</button>
       </div>
     </form>
     <transition name="fade">
       <div v-if="notification" class="notification bg-green-500 text-white p-4 rounded">
         {{ notification }}
       </div>
     </transition>
     <table class="table-auto w-full mt-4">
       <thead>
         <tr>
           <th class="px-4 py-2">Date</th>
           <th class="px-4 py-2">Distribution</th>
           <th class="px-4 py-2">Metrics</th>
           <th class="px-4 py-2">Actions</th>
         </tr>
       </thead>
       <tbody>
         <tr v-for="report in reports" :key="report.id">
           <td class="border px-4 py-2">{{ report.date }}</td>
           <td class="border px-4 py-2">{{ report.distribution }}</td>
           <td class="border px-4 py-2">{{ report.metrics.join(", ") }}</td>
           <td class="border px-4 py-2">
             <button class="btn btn-info bg-blue-500 text-white px-4 py-2 rounded" @click="viewReport(report.id)">View</button>
             <button class="btn btn-secondary bg-gray-500 text-white px-4 py-2 rounded" @click="downloadPDF(report.id)">Download PDF</button>
           </td>
         </tr>
       </tbody>
     </table>
   </div>
 </template>
 
 <script>
 export default {
   data() {
     return {
       searchQuery: '',
       reports: [],
       notification: ''
     };
   },
   methods: {
     searchReports() {
       // Your search logic here
       this.notification = 'Search completed!';
       setTimeout(() => {
         this.notification = '';
       }, 3000);
     },
     viewReport(id) {
       // Your view report logic here
     },
     downloadPDF(id) {
       // Your download PDF logic here
     }
   }
 };
 </script>
 
 <style>
 .fade-enter-active, .fade-leave-active {
   transition: opacity 0.5s;
 }
 .fade-enter, .fade-leave-to /* .fade-leave-active in <2.1.8 */ {
   opacity: 0;
 }
 </style>