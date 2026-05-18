# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create a sample user
User.find_or_create_by!(email: 'user@example.com') do |user|
   user.password = 'password123'
   user.password_confirmation = 'password123'
 end
 
 # Create sample performance benchmarks for the user
 user = User.find_by(email: 'user@example.com')
 
 user.performance_benchmarks.find_or_create_by!(name: 'Benchmark 1') do |b|
   b.linux_os = 'Ubuntu 22.04'
   b.benchmarks = ['CPU', 'Memory']
   b.results = { cpu: 'Pass', memory: 'Pass' }
 end

 user.performance_benchmarks.find_or_create_by!(name: 'Benchmark 2') do |b|
   b.linux_os = 'Fedora 36'
   b.benchmarks = ['Network']
   b.results = { network: 'Fail' }
 end