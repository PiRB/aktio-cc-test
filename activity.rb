# frozen_string_literal: true

# Class that handles the activity
class Activity
  attr_reader :id, :emission_factor_id, :site_id, :quantity_1, :quantity_2

  def initialize(id:, emission_factor_id:, site_id:, quantity_1:, quantity_2:)
    @id = id
    @emission_factor_id = emission_factor_id
    @site_id = site_id
    @quantity_1 = quantity_1
    @quantity_2 = quantity_2
  end

  def process_emissions(emission_factor:)
    processed_value_co2 = emission_factor.value_co2 * quantities_product
    processed_value_ch4 = emission_factor.value_ch4 * quantities_product
    processed_value_n2o = emission_factor.value_n2o * quantities_product
    processed_value_co2b = emission_factor.value_co2b * quantities_product
    processed_value_ch4b = emission_factor.value_ch4b * quantities_product

    { "value_co2": processed_value_co2, "value_ch4": processed_value_ch4, "value_n2o": processed_value_n2o,
      "value_co2b": processed_value_co2b, "value_ch4b": processed_value_ch4b }
  end

  private

  def quantities_product
    quantity_2.nil? ? quantity_1 : quantity_1 * quantity_2
  end
end
