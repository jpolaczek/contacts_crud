Rails.application.routes.draw do
  resources :contacts do
    get :search, on: :collection
  end
  root 'contacts#index'
end
