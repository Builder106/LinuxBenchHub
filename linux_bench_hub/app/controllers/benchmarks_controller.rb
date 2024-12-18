class BenchmarksController < ApplicationController
   def index
     @benchmarks = Benchmark.all
   end
 
   def show
     @benchmark = Benchmark.find(params[:id])
   end
 
   def new
     @benchmark = Benchmark.new
   end
 
   def create
     @benchmark = Benchmark.new(benchmark_params)
     if @benchmark.save
       redirect_to @benchmark
     else
       render :new
     end
   end
 
   private
 
   def benchmark_params
     params.require(:benchmark).permit(:name, :data)
   end
 end