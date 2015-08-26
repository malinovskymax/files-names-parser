Rails.application.routes.draw do
  root 'index#index'
  get '*path', to: 'index#index'
end
