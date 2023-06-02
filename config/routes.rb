Rails.application.routes.draw do
  root 'home#index'
  post '/generate_charts', to: 'home#generate_charts', as: 'generate_charts'
  post '/upload', to: 'home#upload', as: 'upload'
  get '/assets/*path', to: 'errors#not_found'
end

