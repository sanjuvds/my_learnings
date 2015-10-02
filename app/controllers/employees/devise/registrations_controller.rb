class Employees::Devise::RegistrationsController < Devise::RegistrationsController
  # prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  # prepend_before_filter :require_no_authentication, :only => [ :show]#:new, :create, :cancel ] 
  # prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy]
  #include Devise::Controllers::InternalHelpers
  # prepend_before_filter :require_no_authentication, only: [:new, :create, :cancel]
  prepend_before_filter :authenticate_scope!, only: [:edit, :update, :destroy]
  
  def new
    build_resource({})
    set_minimum_password_length
    yield resource if block_given?
    respond_with self.resource
  end
  
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
 
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        #sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
   
    else
 
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def edit
    render :edit
  end
 
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

   def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_flashing_format?
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

   def cancel
    expire_data_after_sign_in!
    redirect_to new_registration_path(resource_name)
  end

  protected

  def update_needs_confirmation?(resource, previous)
    resource.respond_to?(:pending_reconfirmation?) &&
      resource.pending_reconfirmation? &&
      previous != resource.unconfirmed_email
  end

  # By default we want to require a password checks on update.
  # You can overwrite this method in your own RegistrationsController.
  def update_resource(resource, params)
    resource.update_with_password(params)
  end

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash=nil)
    self.resource = resource_class.new_with_session(hash || {}, session)
  end

  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  # The path used after sign up for inactive accounts. You need to overwrite
  # this method in your own RegistrationsController.
  def after_inactive_sign_up_path_for(resource)
    scope = Devise::Mapping.find_scope!(resource)
    router_name = Devise.mappings[scope].router_name
    context = router_name ? send(router_name) : self
    context.respond_to?(:root_path) ? context.root_path : "/"
  end

  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    signed_in_root_path(resource)
  end

  # Authenticates the current scope and gets the current resource from the session.
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", force: true)
    self.resource = send(:"current_#{resource_name}")
  end

  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up)
  end

  def account_update_params
    devise_parameter_sanitizer.sanitize(:account_update)
  end

  def translation_scope
    'devise.registrations'
  end

  #DE2549 Swati Ahire 21-02-2014
  # before_filter :get_js_css
  # GET /users/change_password
  # def change_password    
    # @user = User.new     
    # @user = current_user
    # #US1144 Swati Ahire 06-02-2014: Remove SSO condition
    # # validation to check for SSO authentication or Guest or Union Admin and check for university_sign_on
    # #if ((!@user.nil? && !@user.id.nil?) && ((@union.shibboleth_sign_on == false && @union.university_sign_on == false) || ((!@user.nil? && !@user.userable_type.nil?) && @user.userable_type == "Guest" || @user.userable_type == "Admin" )))
    # #Removed condition to check if user is Admin or Guest in case SSO is turned on      
    # if (!@user.nil? && !@user.id.nil?)
      # #US1144 Swati Ahire 11-02-2014: Added condition to raise exception if user who doesn't have password, tries accesing Change Password screen by manipulating URL      
      # #US1451 [Urvi on 24/12/2014:] :modified the condition to check for blank. Making the condition logically correct.
      # if @user.encrypted_password.blank?
        # raise ActiveRecord::RecordNotFound
      # else
        # render :change_password
      # end
    # else
      # redirect_to home_index_path
    # end
  # end
  
  # POST /users/update_password  
  # added for change password and its validations-US395   
  # def update_password
    # #To find the current user.
    # #Cross union changes to find the union.
    # #Mradula [16-07-2013]
    # @user = current_user     
    # @current_password_value = ''
    # @invalid_current_pwd = ''
    # @password_value = ''
    # @password_confirmation_value = ''
    # #if existing password is blank.
    # if params[:user][:current_password].blank? 
      # @current_password_value = "can't be blank and is invalid"      
    # else
      # #if existing password is wrong.
      # if !@user.valid_password?(params[:user][:current_password])
        # @current_password_value = "is invalid"
      # end
    # end
    # #if new password is blank.
    # if params[:user][:password].blank? 
      # @password_value = "can't be blank"   
    # elsif params[:user][:password].size < 6                 
      # @password_value = "It should be of minimum 6 characters."    
    # end
    # #US904 : confirm pwd is removed from page hence all validation are removed
    # #Abhishek ON 13/06/2013
    # #if confirm password is blank.
    # #if params[:user][:password_confirmation].blank?
    # #  @password_confirmation_value = "can't be blank"      
      # # elsif params[:user][:password_confirmation].size < 6
      # # @password_confirmation_value = "It should be of minimum 6 characters."     
   # # end
#     
    # respond_to do |format|     
      # #if new and confirm passwords are not blank 
      # if (!params[:user][:password].blank? )#and !params[:user][:password_confirmation].blank?)
        # if(params[:user][:password].size >= 6 )           
          # #if new and confirm passwords are same
          # #US904 : confirm pwd is removed from page hence all validation are removed
          # #Abhishek ON 13/06/2013
          # #US1144 Swati Ahire 07-02-2014: Uncommented condition to check if new and existing passwords are same
          # if params[:user][:current_password] != params[:user][:password]
            # # function is used to update the changed password             
            # if @user.update_with_password(params[:user])
              # sign_in @user, :bypass => true               
              # format.html { redirect_to my_subscriptions_user_groups_path, notice: 'Your password updated successfully.' }
              # format.json { render json: @user, status: :updated, location: @user }
            # else
              # format.html { redirect_to :action => :change_password , :current_pwd =>  @current_password_value, :invalid_pwd => @invalid_current_pwd, :pwd => @password_value}#, :pwd_confirmation => @password_confirmation_value}
              # format.json { render json: @user.errors, status: :unprocessable_entity }              
            # end
          # #US904 : confirm pwd is removed from page hence all validation are removed
          # #Abhishek ON 13/06/2013
          # #US1144 Swati Ahire 07-02-2014: Uncommented condition to display new and existing password validation
          # else
            # format.html { redirect_to :action => :change_password , :current_pwd =>  @current_password_value, :invalid_pwd => @invalid_current_pwd, :pwd => t(:new_existing_pwd_validation), :pwd_confirmation => @password_confirmation_value}
            # format.json { render json: @user.errors, status: :unprocessable_entity }
          # end 
        # else
          # #US904 : confirm pwd is removed from page hence params of confirmed pwd is removed
          # #Abhishek ON 13/06/2013
          # @password_value = "It should be of minimum 6 characters."
          # format.html { redirect_to :action => :change_password , :current_pwd =>  @current_password_value, :invalid_pwd => @invalid_current_pwd, :pwd => @password_value}#, :pwd_confirmation => @password_confirmation_value}
          # format.json { render json: @user.errors, status: :unprocessable_entity }
        # end 
      # else
        # #US904 : confirm pwd is removed from page hence params of confirmed pwd is removed
        # #Abhishek ON 13/06/2013
        # format.html { redirect_to :action => :change_password , :current_pwd =>  @current_password_value, :invalid_pwd => @invalid_current_pwd, :pwd => @password_value}#, :pwd_confirmation => @password_confirmation_value}
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      # end      
    # end      
  # end  
end
