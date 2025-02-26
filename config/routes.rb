Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  root "reporting_movies#overview"

  # Authentication
  post "signup", to: "authentication#signup"
  post "login", to: "authentication#login"
  post "logout", to: "authentication#logout"

  # Reporting Movies
  get "reporting_movies/overview", to: "reporting_movies#overview"

  %i[ votes ].each do |model|
    resources model, only: %i[ create destroy update ]
  end

  %i[ movies ].each do |model|
    resources model, only: %i[ new create show update ]
  end
end
