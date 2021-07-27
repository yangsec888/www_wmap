#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++

Rails.application.routes.draw do
  resources :site_urls
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}
  devise_scope :user do
    get 'users/list' => 'users#index'
    get 'users/report' => 'users#report'
    get 'users/:id' => 'users#show'
    delete '/users/logout' => 'devise/sessions#destroy'
  end
  get 'users/edit'
  post 'users/edit_save'
  resources :users
  ###############################
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  ###############################

  root 'home#page'
  get 'home/page'
  get 'home/support_contact'
  get 'home/about'

  ################################

  get 'seed/start'
  post 'seed/start'
  get 'seed/load_file'
  post 'seed/save_file'
  get 'seed/discovery'
  post 'seed/discovery'
  get 'seed/distest'
  post 'seed/distest'
  get 'seed/confirm_email'
  post 'seed/confirm_email'

  ################################

  get 'domains/index'
  get 'domains/show'
  #get 'domains/show_all'
  get 'domains/edit'
  post 'domains/edit_domain'
  post 'domains/save_domain'
  post 'domains/edit'
  post 'domains/update'
  delete 'domains/destroy'
  get 'domains/load_file'
  post 'domains/save_file'
  get 'domains/import'
  get 'domains/search'
  get 'domains/search_list'
  post 'domains/search_list'
  post 'domains/save_import'

 ################################

  get 'cidrs/index'
  get 'cidrs/edit'
  get 'cidrs/import'
  post 'cidrs/save_import'
  post 'cidrs/edit'
  get 'cidrs/load_file'
  post 'cidrs/save_file'

 ################################


  get 'hosts/index'
  post 'hosts/edit'
  get 'hosts/load_file'
  post 'hosts/save_file'

  ################################
  #resources :documents

  #get 'documents/index'

  ################################
  get 'support/faq'
  get 'support/contact'

  ################################

  get 'sites/index'
  get 'sites/show'
  post 'sites/edit'
  get 'sites/load_file'
  post 'sites/save_file'
  #get 'sites/import'
  post 'sites/search'
  #post 'sites/save'
  post 'sites/download'

  ################################

  get 'logs/list'
  get 'logs/show'
  post 'logs/download'
  #resources :logs


  # Yml Settings Controller
  get 'yml_settings/index'
  get 'yml_settings/load_file'
  post 'yml_settings/save_file'

################################
  get 'reports/index'
  get 'reports/new'
  #get 'reports/division'
  get 'reports/download'
  get 'reports/download_all'
  resources :reports

################################
  resources :uploads, only: [:new, :create, :destroy]
  get '/uploads/dt'
  get '/uploads/division_1'
  get '/uploads/division_2'
  get '/uploads/division_3'
  ###
  #get "uploads/index"
  post "uploads/update"
  get "uploads/refresh"
  get "uploads/create"
  get "uploads/alert_uploads"

################################
  get 'domain_map/show'
  post 'domain_map/show'


  #post "uploads/division"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

end
