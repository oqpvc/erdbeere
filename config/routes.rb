Rails.application.routes.draw do
  get 'atoms/show'
  get 'examples/show'
  post 'examples/find'
  
  match 'search', :as => 'main_search', :via => :get, :to => 'main#search'


  root :to => "examples#list"
end
