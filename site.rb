# frozen_string_literal: true

# Class that represents a production site
class Site
  attr_reader :id, :name

  def initialize(id:, name:)
    @id = id
    @name = name
  end

  def get_site_emissions(emissions:)
    emissions.select { |emission| emission.site_id == id }
  end
end
