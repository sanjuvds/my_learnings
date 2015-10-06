Rails.application.routes.draw do
  root :to => 'home#show'
  devise_for :employees, :controllers => {:'devise/unlocks' => "employees/unlocks", :'devise/omniauth_callbacks' => "employees/omniauth_callbacks", :confirmations => "confirmations", :'employees/sessions' => "sessions", :'devise/passwords' => "employees/passwords" ,
    :'devise/registrations' => "employees/registrations"}
    
    
  # devise_for :employees, :controllers => { :registrations => "devise/registrations" }, :skip => [:sessions] do 
    # get 'signup' => 'devise/registrations#new', :as => :new_employee_registration 
    # post 'signup' => 'devise/registrations#create', :as => :employees_registration 
  # end  
    
  # resources :employees
  resources :timesheets do
        get 'approve'
        get 'reject' 
        
  end      
  resources :managers 
end
