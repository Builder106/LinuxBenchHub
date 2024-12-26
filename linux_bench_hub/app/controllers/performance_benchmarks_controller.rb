class PerformanceBenchmarksController < ApplicationController
   before_action :authenticate_user!, except: [:index, :show, :new, :create]
   before_action :set_benchmark, only: [:show]
 
   def index
      # if current_user
      #   @performance_benchmarks = current_user.performance_benchmarks.order(created_at: :desc)
      # else
      @performance_benchmarks = PerformanceBenchmark.order(created_at: :desc)
   end
 
   def show
   end
 
   def new
      @performance_benchmark = current_user ? current_user.performance_benchmarks.new : PerformanceBenchmark.new
   end
 
   def create
      @performance_benchmark = current_user ? current_user.performance_benchmarks.new(performance_benchmark_params) : PerformanceBenchmark.new(performance_benchmark_params)
      
      if @performance_benchmark.save
        BenchmarkService.run_benchmark(@performance_benchmark)
        redirect_to @performance_benchmark, notice: 'Benchmark was successfully created.'
      else
        render :new
      end
    end
 
   def debian
     @performance_benchmarks = current_user.performance_benchmarks.where(linux_os: 'Debian').order(created_at: :desc)
     render :index
   end
 
   def fedora
     @performance_benchmarks = current_user.performance_benchmarks.where(linux_os: 'Fedora').order(created_at: :desc)
     render :index
   end
 
   def ubuntu
     @performance_benchmarks = current_user.performance_benchmarks.where(linux_os: 'Ubuntu').order(created_at: :desc)
     render :index
   end
 
   def compare
     @benchmark1 = current_user.performance_benchmarks.find(params[:benchmark1_id])
     @benchmark2 = current_user.performance_benchmarks.find(params[:benchmark2_id])
   end
 
   def export
     @performance_benchmark = current_user.performance_benchmarks.find(params[:id])
     respond_to do |format|
       format.csv { send_data @performance_benchmark.to_csv, filename: "benchmark-#{@performance_benchmark.id}.csv" }
       format.json { render json: @performance_benchmark }
     end
   end
 
   def share
     @performance_benchmark = current_user.performance_benchmarks.find(params[:id])
     # Implement sharing logic, e.g., generating a shareable link or inviting users
   end
 
   private
 
   def set_benchmark
      @performance_benchmark = PerformanceBenchmark.find(params[:id])
   end
 
   def performance_benchmark_params
      params.require(:performance_benchmark).permit(:name, :description, :linux_os, benchmarks: [], results: {}, configuration: {})
    end
 end