Rails.application.routes.draw do
  root to: redirect('/de')
  scope '/:locale', locale: /#{I18n.available_locales.join('|')}/ do
    resources :examples
    post '/examples/find'

    match 'search', as: 'main_search', via: :get, to: 'main#search'

    get '/' => 'examples#list'
  end
end
