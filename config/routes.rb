Rails.application.routes.draw do
  
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
  
  root 'welcome#index'
  
  get 'thanks' => 'welcome#thanks'
  get 'usage' => 'welcome#usage'
  
  get 'inactive_translations' => 'translations#inactive', :as => :inactive_translations

end
