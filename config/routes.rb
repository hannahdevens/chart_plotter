Rails.application.routes.draw do
  root 'home#index'
  post '/upload', to: 'home#upload'
  post '/generate_chart', to: 'home#generate_chart'
end
