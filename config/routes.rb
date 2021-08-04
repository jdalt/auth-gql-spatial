Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'

  match 'graphql', to: 'graphql#execute', via: %i[get post]
  post 'graphql-introspect', to: 'graphql#introspect'
end
