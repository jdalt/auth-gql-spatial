# frozen_string_literal: true

module Queries
  class Field < GraphQL::Schema::Resolver
    type Types::Field, null: true
    description 'Retrieve a field by Sentera ID'

    argument :id, ID, required: true, description: 'The Sentera ID of the Field being retrieved'

    def resolve(args)
      field = ::Field.find(args[:id])
      field
    end
  end
end
