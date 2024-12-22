class PerformanceBenchmarksController < ApplicationController
   def index
     @performance_benchmarks = PerformanceBenchmark.all
   end
 
   def show
     @performance_benchmark = PerformanceBenchmark.find(params[:id])
   end
 
   def new
     @performance_benchmark = PerformanceBenchmark.new
   end
 
   def create
     @performance_benchmark = PerformanceBenchmark.new(performance_benchmark_params)
     if @performance_benchmark.save
       redirect_to @performance_benchmark
     else
       render :new
     end
   end
 
   private
 
   def performance_benchmark_params
     params.require(:performance_benchmark).permit(:name, :linux_os, benchmarks: [])
   end
 end