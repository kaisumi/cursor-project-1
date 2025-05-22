Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Authentication routes
  post '/auth/login', to: 'auth#login'
  get '/auth/verify', to: 'auth#verify'
  delete '/auth/logout', to: 'auth#logout'

  # Root path
  root "home#index"
end
