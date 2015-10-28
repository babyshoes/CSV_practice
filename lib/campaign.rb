require_relative '../config/environment'

class Campaign
  attr_reader :name, :date, :spend, :impressions, :actions, :object_type

  @@all = []

  def self.all
    @@all
  end

  def initialize(row_of_data)
    @name = row_of_data['campaign']
    @date = row_of_data['date']
    @spend = row_of_data['spend'].to_f
    @impressions = row_of_data['impressions'].to_f
    @actions = eval(row_of_data['actions'])
    @object_type = row_of_data['object_type']
    @@all << self
  end

  def initiative
    name.split('_')[0]
  end

  def audience
    name.split('_')[1]
  end

  def asset
    name.split('_')[2]
  end

end
