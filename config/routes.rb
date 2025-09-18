Rails.application.routes.draw do
  root "articles#index"

  resources :articles do
    member do
      post :restore
    end
    resources :transfers, only: [ :new, :create ]
  end

  resources :people do
    member do
      post :restore
    end
  end
  resources :transfers, only: [ :index, :show, :destroy ] do
    member do
      post :restore
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
