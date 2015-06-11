Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :users, only: [] do
      resources :gift_cards, only: [] do
        collection do
          get :lookup
          post :redeem
        end
      end

      collection do
        resources :gift_cards, only: [:index, :show, :new, :create]
      end
    end
  end

  namespace :api, defaults: { format: 'json' } do
    resources :gift_cards, only: [] do
      collection do
        post :redeem
      end
    end
  end
end
