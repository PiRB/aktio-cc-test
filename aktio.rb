# frozen_string_literal: true
require 'json'

# TODO : Maybe use something like Zeitwerk to initialize all the classes and not have to import all the classes

require_relative 'site'
require_relative 'emission_category'
require_relative 'emission_factor'
require_relative 'activity'
require_relative 'emission'
require_relative 'service/create_emissions'

INPUT_FILE_PATH = './data/input.json'
OUTPUT_FILE_PATH = './data/output.json'
INPUT_FILE = File.read(INPUT_FILE_PATH)

File.open(OUTPUT_FILE_PATH, 'w') {|file| file.truncate(0) }
hash_data = JSON.parse(INPUT_FILE)

# TODO : Refactor in a service that initialize all the arrays

categories_hash = hash_data['emission_categories']
emission_factors_hash = hash_data['emission_factors']
activity_hash = hash_data['activity_data']
sites_hash = hash_data['sites']
sites = []
categories = []
emission_factors_data = []
activities_data = []

# TODO : Create a service that generate all the arrays I need

sites_hash.each do |site|
  sites << Site.new(id: site['id'], name: site['name'])
end

emission_factors_hash.each do |emission_factor|
  emission_factors_data << EmissionFactor.new(id: emission_factor['id'], description: emission_factor['description'],
                                              emission_category_id: emission_factor['emission_category_id'],
                                              unit_1: emission_factor['unit_1'], unit_2: emission_factor['unit_2'],
                                              value_co2: emission_factor['value_co2'], value_ch4: emission_factor['value_ch4'],
                                              value_n2o: emission_factor['value_n2o'], value_co2b: emission_factor['value_co2b'], value_ch4b: emission_factor['value_ch4b'])
end

categories_hash.each do |category|
  categories << EmissionCategory.new(id: category['id'], name: category['name'])
end

activity_hash.each do |activity|
  activities_data << Activity.new(id: activity['id'], emission_factor_id: activity['emission_factor_id'],
                                  site_id: activity['site_id'],
                                  quantity_1: activity['quantity_1'], quantity_2: activity['quantity_2'])
end

emissions = CreateEmissions.new(activities_data:, emission_factors_data:).call

output_data = {}

# TODO : No time but i wanted to create a service to build the json data

sites.each do |site|
  site_emissions = site.get_site_emissions(emissions:)
  categories_data = {}
  categories.each do |category|
    emissions_arr = []
    category.get_emissions(emissions: site_emissions).each do |emission|
      emissions_arr << emission.emission_hash
    end
    categories_data[category.name.to_s] = {
      "total_value": category.get_total_emissions_value(emissions: site_emissions),
      "emissions": emissions_arr
    }
  end
  output_data[site.name.to_s] = categories_data
end

File.open(OUTPUT_FILE_PATH, 'w') {|file| file.write(JSON.pretty_generate(output_data))}
