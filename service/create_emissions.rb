# frozen_string_literal: true
require_relative '../emission'
# Service that handle the creation of all emissions
class CreateEmissions
  attr_reader :activites_data, :emission_factors_data
  def initialize(activities_data:, emission_factors_data:)
    @activites_data = activities_data
    @emission_factors_data = emission_factors_data
  end

  def call
    emission_id = 1
    emissions = []
    emission_factors_data.each do |emission_factor|
      activities = emission_factor.get_activities(activites_data:)
      activities.each do |activity|
        emissions_values = activity.process_emissions(emission_factor:)

        emissions << Emission.new(id: emission_id, description: emission_factor.description, unit: emission_factor.unit,
                                    values: values(emissions_values:), activity_datum_id: activity.id, site_id: activity.site_id,
                                    emission_category_id: emission_factor.emission_category_id)
        emission_id += 1
      end
    end

    emissions
  end

  private

  def values(emissions_values:)
    emissions_values.merge({'total_value': process_total_value(emissions_values:)})
  end

  def process_total_value(emissions_values:)
    emissions_values[:value_co2] + emissions_values[:value_ch4] + emissions_values[:value_n2o] + emissions_values[:value_ch4b]
  end
end

