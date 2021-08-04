# frozen_string_literal: true

module Types
  class GeoJson < GraphQL::Schema::Scalar
    graphql_name 'GeoJSON'
    description 'GeoJSON structure'

    # def self.coerce_input(value, _ctx)
    # end

    def self.coerce_result(value, _ctx)
      if value.respond_to?(:geometry_type)
        # RGeo::GeoJSON.encode(RGeo::GeoJSON::Feature.new(value))
        RGeo::GeoJSON.encode(value)
      else
        # when RGeo can't encode return original value (probably a hash)
        value
      end
    end

  end
end
