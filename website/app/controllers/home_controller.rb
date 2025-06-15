class HomeController < ApplicationController
   def index
     if user_signed_in?
       @recent_benchmarks = current_user.performance_benchmarks.order(created_at: :desc).limit(5)
       @notifications = current_user.notifications.unread
     else
       @recent_benchmarks = PerformanceBenchmark.order(created_at: :desc).limit(5)
     end
   end
 end