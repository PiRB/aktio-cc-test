# frozen_string_literal: true

# Class that represents the categories
class EmissionCategory
  attr_reader :id, :name

  def initialize(id:, name:)
    @id = id
    @name = name
  end

  def get_total_emissions_value(emissions:)
    emission_total_value = 0
    get_emissions(emissions:).each do |emission|
      emission_total_value += emission.values[:total_value]
    end

    emission_total_value
  end

  def get_emissions(emissions:)
    emissions.select { |emission| emission.emission_category_id == id }
  end
end
