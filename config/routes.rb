Kochiku::Application.routes.draw do
  mount Resque::Server.new, :at => '/resque'

  root :to => "projects#index"

  resources :projects, :only => [:index, :new, :show] do
    get 'status-report', :action => "status_report", :on => :collection

    resources :builds, :only => [:create, :show] do
      post 'request', :action => "request_build", :on => :collection
      resources :build_parts, :as => 'parts', :path => 'parts', :only => [:show] do
        post 'rebuild', :on => :member
      end
    end
  end
  match '/XmlStatusReport.aspx', :to => "projects#status_report", :defaults => { :format => 'xml' }

  match '/build_attempts/:build_attempt_id/build_artifacts' => "build_artifacts#create", :via => :post
end
# TODO routing specs