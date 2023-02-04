Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :shops, except: %i[delete] do
        post :buy, on: :member
      end
      resources :users, except: %i[delete]
      resources :cards, only: %i[show index]
    end
  end
end
