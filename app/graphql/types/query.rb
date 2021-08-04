module Types
  class Query < GraphQL::Schema::Object
    field :field, resolver: Queries::Field, extras: [:lookahead]
  end
end
