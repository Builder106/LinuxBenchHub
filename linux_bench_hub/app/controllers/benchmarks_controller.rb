# app/controllers/benchmarks_controller.rb
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
       redirect_to @benchmark, notice: 'Benchmark was successfully created.'
     else
       render :new
     end
   end
 
   def debian
     @benchmarks = PerformanceBenchmark.where(linux_os: 'Debian')
     render :index
   end
 
   def fedora
     @benchmarks = PerformanceBenchmark.where(linux_os: 'Fedora')
     render :index
   end
 
   def ubuntu
     @benchmarks = PerformanceBenchmark.where(linux_os: 'Ubuntu')
     render :index
   end
 
   private
 
   def benchmark_params
     params.require(:performance_benchmark).permit(:name, :description, :linux_os, benchmarks: [])
   end
 end