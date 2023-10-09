# frozen_string_literal: true

# Class that represent an emission factor
class EmissionFactor
  attr_reader :id, :description, :emission_category_id, :unit_1, :unit_2, :value_co2, :value_ch4, :value_n2o, :value_ch4b,
              :value_co2b

  def initialize(id:, description:, emission_category_id:, unit_1:, unit_2:, value_co2:, value_ch4:, value_n2o:, value_co2b:,
                 value_ch4b:)
    @id = id
    @description = description
    @emission_category_id = emission_category_id
    @unit_1 = unit_1
    @unit_2 = unit_2
    @value_co2 = value_co2.to_f
    @value_ch4 = value_ch4.to_f
    @value_n2o = value_n2o.to_f
    @value_co2b = value_co2b.to_f
    @value_ch4b = value_ch4b.to_f
  end

  def get_activities(activites_data:)
    activites_data.select{|activity| activity.emission_factor_id == id}
  end

  def unit
    "#{unit_1}#{ unit_2.nil? ? '' : '.' + unit_2 }"
  end
end
