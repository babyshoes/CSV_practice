require_relative 'campaign'

class DataSource
  attr_accessor :campaign_names, :initiatives, :audiences, :assets, :source1, :source2, :merged_data

  def initialize(source1, source2)
    @campaign_names = []
    @initiatives = []
    @audiences = []
    @assets = []
    @source1 = CSV.read source1, :headers => true
    @source2 = CSV.read source2, :headers => true
    @merged_data = merge_data_sets
    objectify_campaigns
  end

  private

  def determine_names
    source1.each do |row|
      campaign_names << row['campaign']
    end
    campaign_names.uniq!
  end

  def parse_names
    campaign_names.uniq.each do |name|
      split_name = name.split('_')
      initiatives << split_name[0]
      audiences << split_name[1]
      assets << split_name[2]
    end
    initiatives.uniq!; audiences.uniq!; assets.uniq!
  end

  # clean up
  def sanitize_names
    determine_names
    parse_names
    source2.each do |row|
      split_name = row['campaign'].split('_')
        initiative = initiatives.find do |e|
          split_name.find {|name| e == name}
        end
        audience = audiences.find do |e|
          split_name.find {|name| e == name}
        end
        asset = assets.find do |e|
          split_name.find {|name| e == name}
        end
        row['campaign'] = [initiative, audience, asset].join('_')
    end
  end

  def delete_dups
    distinct = []
    source2.each do |row|
      distinct << row if !distinct.include? row
    end
    @source2 = distinct
  end

  def add_column(name)
    source1.each do |row|
      source2.find do |row2|
        row[name] = row2[name] if row['campaign'] == row2['campaign']
      end
    end
  end

  def merge_data_sets
    sanitize_names
    delete_dups
    add_column('object_type')
  end

  def objectify_campaigns
    merged_data.each do |row|
      campaign = Campaign.new(row)
    end
  end
end
