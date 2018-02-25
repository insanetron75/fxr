Rails.application.routes.draw do
  get 'welcome/index'
  get 'welcome/convert', to: 'welcome#convert'

  root 'welcome#index'
end
