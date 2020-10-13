Rails.application.routes.draw do
  # devise_for :admins
  root 'rails_admin/main#dashboard'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope :api do
    devise_for :users, controllers: { sessions: :sessions },
                       path_names: { sign_in: :login }

    resources :users do 
      collection do 
        post :add_designer
        get :get_designer
        get :list
        post :send_varification_code
        post :need_support
      end
    end
    resources :orders
  end
  devise_for :admins, path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'signup' }

  scope :admin  do 
  	resource :user, only: [:show, :update, :edit, :new]
  end
end
