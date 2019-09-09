Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'google_spreadsheets#index'

  resources :google_spreadsheets, only: %i[index new create]
end
