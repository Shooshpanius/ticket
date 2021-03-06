Ticketmanager::Application.routes.draw do
  get "groups/index"
  get "tickets/index"
  #get "users/index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # get ':controller(/:action(/:id))'

  get '/login/' => 'login#index'

  resources :login, :path => 'login/(:action)(.:format)'
  resources :tickets, :path => ':controller/(:action)(.:format)'
  resources :supply, :path => ':controller/(:action)(.:format)'
  resources :pdf, :path => ':controller/(:action)(.:format)'
  resources :problems, :path => 'problems/(:action)(.:format)'
  resources :mail_receiver, :path => 'mail_receiver/(:action)(.:format)'

  #resources :admin/:users , :path => '/admin/users/(:action)(.:format)'

  namespace :admin do
    resources :users, path: 'users/(:action)(:id)(.:format)'
    resources :groups, path: 'groups/(:action)(.:format)'
  end




  root 'main#index'
  #get '/', to: redirect('/login')


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
