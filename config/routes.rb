Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :shops, except: %i[delete]
      resources :users, except: %i[delete]
    end
  end
end
