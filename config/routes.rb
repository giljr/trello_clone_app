Rails.application.routes.draw do
  root "boards#show"

  resources :boards, only: [ :show ] do
    collection do
      patch :sort
    end
  end

  resources :cards, only: [] do
    member do
      patch :sort
    end
  end
end
