Rails.application.routes.draw do
  root 'welcome#index'

  scope '/.well-known' do
    get '/core', to: 'core#index'
    post '/core', to: 'core#create'
  end

  get '/rd',        to: 'rd#index'

  get '/rd-group',  to: 'rd_group#index'

  get '/rd-lookup', to: 'rd_lookup#index'
end
