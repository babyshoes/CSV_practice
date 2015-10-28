
def unique_campaigns(objectified_data, month)
  objectified_data.count do |campaign|
    date = Date.strptime(campaign.date, '%Y-%m-%d')
    date.mon == month
  end
end

def num_actions(type, action)
  action[:x] || action[:y] if action[:action] == type
end

def total_conversions(objectified_data, initiative)
  num_conversions = 0
  objectified_data.each do |campaign|
    if campaign.initiative == initiative
      campaign.actions.each do |action|
        num_conversions += num_actions('conversions', action).to_i
      end
    end
  end
  num_conversions
end

def cheapest_conversions(objectified_data)
  cheapest = objectified_data.min do |campaign|
    campaign.actions.inject(0) {|sum, n| sum + num_actions('conversions', n).to_i}
  end
  "audience: #{cheapest.audience}, asset: #{cheapest.asset}"
end

def total_CPVs(objectified_data, object_type)
  total_spend = total_views = 0
  objectified_data.each do |campaign|
    if campaign.object_type == object_type
      total_spend += campaign.spend
      total_views += campaign.actions.inject(0) {|sum, n| sum + num_actions('views', n).to_i}
    end
  end
  total_spend / total_views
end
