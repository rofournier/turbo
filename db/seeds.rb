# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Seed some tasks that will match the request
require 'date'

days_of_week = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
start_date = Date.today - 7

days_of_week.each_with_index do |day, index|
  3.times do |i|
    Task.find_or_create_by!(name: "Task #{i + 1} for #{day}", user: User.first, created_at: start_date + index, time_spent: 24000)
  end
end
