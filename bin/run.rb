require_relative '../config/environment'

dataset = DataSource.new('data/source1.csv', 'data/source2.csv')
puts "The number of unique campaigns in February was #{unique_campaigns(Campaign.all, 2)}."
puts "The total number of conversions on plants was #{total_conversions(Campaign.all, 'plants')}."
puts "The least expensive conversions were manifest in the audience/asset combination of #{cheapest_conversions(Campaign.all)}."
puts "The total CPV for videos was #{total_CPVs(Campaign.all, 'video')}."
