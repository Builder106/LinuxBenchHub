class DashboardController < ApplicationController
   before_action :authenticate_user!
 
   def index
     @recent_benchmarks = current_user.performance_benchmarks.order(created_at: :desc).limit(10)
     @statistics = {
       total_benchmarks: current_user.performance_benchmarks.count,
       average_score: current_user.performance_benchmarks.average(:score)
     }
   end
 end