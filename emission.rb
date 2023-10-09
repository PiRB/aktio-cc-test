# frozen_string_literal: true

# Class that handles the emissions
class Emission
  attr_reader :id, :description, :unit, :values, :activity_datum_id, :site_id, :emission_category_id

  def initialize(id:, description:, unit:, values:, activity_datum_id:, site_id:, emission_category_id:)
    @id = id
    @description = description
    @unit = unit
    @values = values
    @activity_datum_id = activity_datum_id
    @site_id = site_id
    @emission_category_id = emission_category_id
  end

  def emission_hash
    {
      "id": id,
      "description": description,
      "unit": "kgCO2e/#{unit}",
      "total_value": values[:total_value],
      "value_co2": values[:value_co2].zero? ? nil : values[:value_co2],
      "value_ch4": values[:value_ch4].zero? ? nil : values[:value_ch4],
      "value_n2o": values[:value_n2o].zero? ? nil : values[:value_n2o],
      "value_co2b": values[:value_co2b].zero? ? nil : values[:value_co2b],
      "value_ch4b": values[:value_ch4b].zero? ? nil : values[:value_ch4b],
      "activuty_datum_id": activity_datum_id
    }
  end
end
