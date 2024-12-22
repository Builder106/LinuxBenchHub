class BenchmarksController < ApplicationController
   def index
     @benchmarks = PerformanceBenchmark.all
   end
 
   def show
     @benchmark = PerformanceBenchmark.find(params[:id])
   end
 
   def new
     @benchmark = PerformanceBenchmark.new
   end
 
   def create
     @benchmark = PerformanceBenchmark.new(benchmark_params)
     if @benchmark.save
       BenchmarkService.run_benchmark(@benchmark.name, @benchmark.linux_os)
       redirect_to @benchmark
     else
       render :new
     end
   end
 
   private
 
   def benchmark_params
      params.require(:performance_benchmark).permit(:name, :description, :linux_os, benchmarks: [])
    end
 end