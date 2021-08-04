# frozen_string_literal: true

module Types
  class Field < GraphQL::Schema::Object
    description 'Field'
    field :name, String, null: false, description: 'Field name.'
    field :grower, String, null: true, description: 'Field grower name.'
    field :farm, String, null: true, description: 'Field farm name'
    field :boundary, Types::GeoJson, null: false, description: 'MultiPolygon boundary of a Field'
  end
end
