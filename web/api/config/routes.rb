Rails.application.routes.draw do
  get "/fixed_links/:comment_id/get" => "fixed_links#get", as: 'get_fixed_link'
  get "/favorites" => "favorites#index"
  post "/favorites/:record_type/:record_id/create" => "favorites#create"
  post "/favorites/:record_type/:record_id/destroy" => "favorites#destroy"

  post "/likes/:thread_type/:thread_id/create" => "likes#create"
  post "/likes/:thread_type/:thread_id/destroy" => "likes#destroy"
  get '/notifications/fetch', to: 'notifications#fetch', as: 'fetch_notification'
  resources :notifications
  resources :comments
  get '/calendars/agenda', to: 'calendars#agenda', as: 'agenda_calendar'
  get '/calendars/weekly', to: 'calendars#weekly', as: 'weekly_calendar'
  post '/calendars/create_comment', to: 'calendars#create_comment', as: 'create_calendar_comment'
  resources :calendars
  get 'welcome/index'
  resources :settings
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'groups#index'

  devise_for :accounts, controllers: {
    :sessions      => "accounts/sessions",
    :registrations => "accounts/registrations",
    :passwords     => "accounts/passwords"
  }

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  resources :groups do
    get '/group_configurations/main', to: 'group_configurations#main'
    get '/group_configurations/theme', to: 'group_configurations#theme'
    get '/group_configurations/mail', to: 'group_configurations#mail'
    get '/group_configurations/event', to: 'group_configurations#event'
    get '/group_configurations/facility', to: 'group_configurations#facility'
    get '/group_configurations/status', to: 'group_configurations#status'
    resources :group_configurations
    patch '/cabinets/:id/revert', to: 'cabinets#revert'
    get '/cabinets/:id/restore/:version', to: 'cabinets#restore', as: 'cabinet_restore'
    resources :cabinets
    resources :boards
    # TODO: これいる？
    get '/projects/new', to: 'projects#new'
    post '/projects', to: 'projects#create'
    get '/projects/:id', to: 'projects#dashboard', as: 'dashboard'
    resources :projects
    resources :invites do
      get '/token/:uuid', :to => 'invites#token'
      get '/error', :to => 'invites#error'
    end
  end
  get '/joined_projects', action: :joined_projects, controller: 'projects', as: 'joined_projects'
  # get '/groups/:group_id/projects/:project_id', to: 'projects#dashboard', as: 'dashboard'
  resources :users
  resources :memos
  patch '/memos/:id/mark_as_read', to: 'memos#mark_as_read', as: 'memo_mark_as_read'
  resources :standard_operations
  patch '/standard_operations/:project_id', to: 'standard_operations#update'
  resources :tasks
  patch '/tasks/:project_id', to: 'tasks#update'
  resources :timers
  patch '/timers/:project_id', to: 'timers#update'
  resources :working_hours
end
