Rails.application.routes.draw do
  # WARNING! The order of the scope matters
  # In the event we were to add new versions, they would have to be defined above the default version since Rails
  # will cycle through all routes from top to bottom searching for one that matches(till method matches? resolves to true).

  # module the controllers without affecting the URI
  scope module: :v2, constraints: ApiVersion.new('v2') do
    resources :todos, only: :index
  end

  # namespace the controllers without affecting the URI
  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    resources :todos do
      resources :items
    end
  end

  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
end
