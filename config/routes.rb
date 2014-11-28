Rails.application.routes.draw do
  root 'welcome#index'

  scope '/.well-known' do
    resources :core, only: [:index, :create]
  end
end
