# app/controllers/benchmarks_controller.rb
class BenchmarksController < ApplicationController
   before_action :authenticate_user!
   before_action :set_benchmark, only: [:show]
 
   def index
     @benchmarks = current_user.performance_benchmarks.order(created_at: :desc)
   end
 
   def show
   end
 
   def new
     @benchmark = current_user.performance_benchmarks.new
   end
 
   def create
     @benchmark = current_user.performance_benchmarks.new(benchmark_params)
     if @benchmark.save
       redirect_to @benchmark, notice: 'Benchmark was successfully created.'
     else
       render :new
     end
   end
 
   def debian
     @benchmarks = current_user.performance_benchmarks.where(linux_os: 'Debian').order(created_at: :desc)
     render :index
   end
 
   def fedora
     @benchmarks = current_user.performance_benchmarks.where(linux_os: 'Fedora').order(created_at: :desc)
     render :index
   end
 
   def ubuntu
     @benchmarks = current_user.performance_benchmarks.where(linux_os: 'Ubuntu').order(created_at: :desc)
     render :index
   end
 
   private
 
   def set_benchmark
     @benchmark = current_user.performance_benchmarks.find(params[:id])
   end
 
   def benchmark_params
     params.require(:performance_benchmark).permit(:name, :description, :linux_os, benchmarks: [], results: {})
   end
 end