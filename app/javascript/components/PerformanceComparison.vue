<template>
   <div class="container">
     <h1>Performance Comparison</h1>
     <canvas id="comparisonChart"></canvas>
   </div>
 </template>
 
 <script>
 import { Chart } from 'chart.js';
 
 export default {
   props: ['labels', 'datasets'],
   mounted() {
     const ctx = document.getElementById('comparisonChart').getContext('2d');
     new Chart(ctx, {
       type: 'bar',
       data: {
         labels: this.labels,
         datasets: this.datasets,
       },
       options: {
         responsive: true,
         scales: {
           y: {
             beginAtZero: true,
           },
         },
       },
     });
   },
 };
 </script>