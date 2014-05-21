Rails.application.routes.draw do
  
  resources :translators

  resources :songs do
    resources :translations
  end
  
  resources :languages
  
  resources :genres
  
  root 'welcome#index'
  get 'thanks' => 'welcome#thanks'
  get 'usage' => 'welcome#usage'

end
