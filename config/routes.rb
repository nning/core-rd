Rails.application.routes.draw do
  root 'welcome#index'

  scope '/.well-known' do
    get '/core', to: 'core#index'
  end

  post   '/rd',     to: 'rd#create'
  get    '/rd/:id', to: 'rd#show'
  post   '/rd/:id', to: 'rd#update'
  delete '/rd/:id', to: 'rd#destroy'

  post   '/rd-group',     to: 'rd_group#create'
  delete '/rd-group/:id', to: 'rd_group#destroy'

  get '/rd-lookup/:type', to: 'rd_lookup#lookup', as: 'rd_lookup'
end
