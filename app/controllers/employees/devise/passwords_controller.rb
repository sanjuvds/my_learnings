class Employees::Devise::PasswordsController < Devise::PasswordsController
  prepend_before_filter :require_no_authentication
  
  #include Devise::Controllers::InternalHelpers
  # GET /users/password/new
  def new
    build_resource({})
    render :new
  end
  
  # POST /users/password
  #validation is added for SSO authentication for reset password-US395
  def create
    puts "Reset password calls this...................................."
    #Z281 : email converted to downcase so that if user enters any capital letter then also it will find the user.
    #Abhishek on 22/10/2013 
    email = params[:employee][:email].downcase
    if email.nil? or (!email.nil?and email.blank?)
      @sso_auth_message = t :email_address_empty
      flash[:error] = @sso_auth_message
      redirect_to new_employee_password_path()
    else 
      # Check if it is NUS Admin
      if @is_nusadmin
        @user = User.find_by_email_and_union_id(email, nil)
        self.resource = resource_class.send_reset_password_instructions(params[resource_name])
        
        if successfully_sent?(resource)
          respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name,email))
        else
          respond_with_navigational(resource){ render :new }
        end
      else
        #US1064 - Finding user with his/her email and alternate email.
        #Mradula [17-12-2013] 
        #Sanity defect R18_Interim :While reset password, if user not entered captcha and entered only mail id then getting sorry page on click of reset button 
        @user = User.get_valid_user_by_email_or_alternate_email(email,@union.id).first
        #Bug-1645 if user is nill, just display error message
        #DE2432[Jagdish on 24/1/2014] : blank check was missing  
        if @user.nil? or @user.blank? 
          # message is added in global constant
          #Abhishek Singh On 13/06/2013
          @sso_auth_message = t :email_not_found
          #@sso_auth_message = "Entered email is not found in Unioncloud."
          flash[:error] = @sso_auth_message
          redirect_to new_user_password_path()
          # validation to check for SSO authentication or Guest or Union Admin
          #US754 - added check for university_sign_on
          #US1144 Swati Ahire 07-02-2014: Removed condition for checking SSO
          #elsif ( (@union.shibboleth_sign_on == false && @union.university_sign_on == false) || @user.userable_type == "Guest" || @user.userable_type == "Admin")
        else
          #US904 : recaptcha validation is added for forgotten password page
          #Abhishek Singh on 13/06/2013
          #US1144 Swati Ahire 11-02-2014: If user has not completed registration and if he/she tries resetting password, redirect to reset password screen with error message
          
          #US1438 Urvi 31-12-2014: Added a check for nus connect user which will be displayed when he is already register but his approval is pending and does a click on forget password link.
          if @user.present? && @user.userable_type == GlobalConstants::CONNECT_USER                 
            connect_user = ConnectUser.find_by_email(params[:user][:email])            
            if connect_user.present?  
              if connect_user.approval_status == GlobalConstants::APPROVAL_PENDING
                flash[:error] = t(:approval_pending_error_message)
                redirect_to new_user_password_path() and return false
              end                         
            end            
          end
          
          if !@user.confirmation_token.nil? && !@user.confirmed_at?
            flash[:error] = t(:reset_password_error)
            redirect_to new_user_password_path() and return false
          end                   
          
          if verify_recaptcha(:model => resource, :attribute => :recaptcha)            
            self.resource = resource_class.send_reset_password_instructions(params[resource_name])
            if successfully_sent?(resource)
              #US904: email is sent as params to show email of user on reset pwd instruction page
              #Abhishek Singh On 13/06/2013
              respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name,email))
            else
              respond_with_navigational(resource){ render :new }
            end
          else
            #US904: if captcha validation is thrown
            #Abhishek Singh On 13/06/2013
            flash[:error] = t :captcha_validation
            redirect_to new_user_password_path()
          end
          # else
          # #US1144 Remove this condition to allow user to reset password
          # @sso_auth_message = "Your account is configured to logon via the university's portal.  Please visit portal to reset your password."
          # flash[:error] = @sso_auth_message
          # redirect_to new_user_password_path()
        end
      end
    end
    
  end
  
  # GET /resource/password/edit?reset_password_token=p3oiMQsebwvUn7kgNtqM
  def edit
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
    render :edit
  end
  
  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(params[resource_name])
    
    if resource.errors.empty?
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      sign_in(resource_name, resource)
      #US1144 Swati Ahire 10-02-2014: Dashboard was not displayed to Admin after password is reset because 
      #session[:admin_access] was not set to true. Added check to add session[:admin_access] if user is admin
      #Z1750 [Shoba: 17-Jul-2014] : moved the permission check to application_controller 
      if !@union.nil?
        set_session_values(current_user)
      end
      respond_with resource, :location => after_sign_in_path_for(resource)
    else
      respond_with_navigational(resource){ render :edit }
    end
  end
  
  #US904 : new method added which will redirect user to new page containg reset pwd info.
  #Abhishek Singh On 13/06/2013
  def reset_password_message()
    respond_with_navigational(resource){ render :reset_password_message }
  end
  
  protected
  #Overidden devise after_sending_reset_password_instructions_path_for
  # For #US904: resource is sent as params to show email of user on change pwd instruction page
  #Abhishek Singh On 13/06/2013
  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name,email)
    #US904 : 
    #condition added for users except nusadmin so that it will redirect user to new page containg reset pwd info.
    # with user_email as params to display email on reset pwd message page.
    #Abhishek Singh On 13/06/2013
    if @is_nusadmin
      new_session_path(resource_name)
    else
      users_password_reset_password_message_path(:user_email => email)
    end
  end
  
end
