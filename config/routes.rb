Myapp::Application.routes.draw do

  authenticated :user do
   root :to => 'dashboard#index'
  end

  root :to => "home#index"

  devise_for :users, :controllers => { :registrations => "registrations" }
  as :user do
    get '/change_password', :to => 'registrations#change_password'
    put '/update_password', :to => 'registrations#update_password'
    get '/settings', :to => 'registrations#edit', :as => :settings
  end

  match '/scanme' => 'scan#index'
  match '/scan/scan' => 'scan#scan'

  get '/dashboard', :to => 'dashboard#index'
  match "/dashboard/graph/:fid/:duration_ts/:duration_te/:graph" => "dashboard#graph", :as => :dashboard_graph
  match "/:fid/:w_type/:lab/:run/:opts/collect(.:format)" => "collect#index", :as => :collect
  match "/:fid/:w_type/:lab/:opts/inspect(.:format)" => "inspect#index", :as => :inspect
  match "/:fid/:w_type/:lab/:opts/overlay(.:format)" => "overlay#index", :as => :overlay

  get '/configuration', :to => 'configuration#index'
  post '/configuration/purge_data', :to => 'configuration#purge_data'
  get '/inspect/:fid', :to => 'inspect#index'
  get '/tracking', :to => 'tracking#index'
  get '/help', :to => 'help#index'
end
