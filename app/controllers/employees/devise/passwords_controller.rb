class Employees::Devise::PasswordsController < Devise::PasswordsController
  prepend_before_filter :require_no_authentication
  def new
    build_resource({})
    render :new
  end

  # POST /users/password
  def create
    email = params[:employee][:email].downcase
    if email.nil? or (!email.nil?and email.blank?)
      @sso_auth_message = t :email_address_empty
      flash[:error] = @sso_auth_message
      redirect_to new_employee_password_path()
    else
      if @is_nusadmin
        @user = User.find_by_email_and_union_id(email, nil)
        self.resource = resource_class.send_reset_password_instructions(params[resource_name])

        if successfully_sent?(resource)
          respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name,email))
        else
          respond_with_navigational(resource){ render :new }
        end
      else
        @user = User.get_valid_user_by_email_or_alternate_email(email,@union.id).first
        if @user.nil? or @user.blank?
          @sso_auth_message = t :email_not_found
          flash[:error] = @sso_auth_message
          redirect_to new_user_password_path()
        else
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

          self.resource = resource_class.send_reset_password_instructions(params[resource_name])
          if successfully_sent?(resource)
            respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name,email))
          else
            respond_with_navigational(resource){ render :new }
          end
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
      if !@union.nil?
        set_session_values(current_user)
      end
      respond_with resource, :location => after_sign_in_path_for(resource)
    else
      respond_with_navigational(resource){ render :edit }
    end
  end

  def reset_password_message()
    respond_with_navigational(resource){ render :reset_password_message }
  end

  protected

  def after_sending_reset_password_instructions_path_for(resource_name,email)
    if @is_nusadmin
      new_session_path(resource_name)
    else
      users_password_reset_password_message_path(:user_email => email)
    end
  end
end
