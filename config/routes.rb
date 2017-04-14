Rails.application.routes.draw do
  get 'atoms/show'

  get 'examples/show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "examples#list"
end
