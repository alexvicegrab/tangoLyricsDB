Rails.application.routes.draw do

  devise_for :users
  resources :translators

  resources :songs do
    resources :translations do
      member do
        put :check_link
      end
    end
  end
  
  resources :languages
  
  resources :genres
  
  root 'songs#index'
  
  get 'about' => 'welcome#about'
  get 'stats' => 'welcome#stats'
  get 'usage' => 'welcome#usage'
  
  get 'translations' => 'translations#index', :as => :translations
  get 'inactive_translations' => 'translations#inactive', :as => :inactive_translations

end
