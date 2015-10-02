class Users::Devise::UnlocksController < Devise::UnlocksController
  prepend_before_filter :require_no_authentication
  #include Devise::Controllers::InternalHelpers
  # US904
  # devise method overriden
  # when user clicks on  didn't recive unlock instructions?. he will be redirected to resend unlock page
  # afer putting his email id and clicking resend unlock instuction user will be redirected to new page containing instructions.
  #Abhishek Singh On 13/06/2013
  # POST /resource/unlock
  def create
    
    #US1438 Urvi 31-12-2014 Added code and condition to verify the email for connect user and check for approval pending before sending the unlock instruction mail.  
    union_id = params[:user][:union_id]
    email = params[:user][:email]    
    if !union_id.nil? && !union_id.blank? && !email.nil? && !email.blank?      
      user = User.get_valid_user_by_email_or_alternate_email(email,union_id).first
    end
    if user.present? && user.userable_type == GlobalConstants::CONNECT_USER              
      connect_user = ConnectUser.find_by_email(email.strip.downcase)                                 
      if connect_user.present? && connect_user.approval_status == GlobalConstants::APPROVAL_PENDING                                                  
          flash[:error] = t(:approval_pending_error_message)
          redirect_to new_unlock_path(@union.users.new)                  
      else
          send_unlock_instructions_for_user
      end                                                                      
    else             
      send_unlock_instructions_for_user
    end  
  end

  #US904 : new method added which will redirect user to new page containg account lock info.
  #Abhishek Singh On 13/06/2013
  def account_lock_message()
    respond_with_navigational(resource){ render :account_lock_message }
  end

  protected

  #Overidden devise after_sending_unlock_instructions_path_for
  # For #US904: resource is sent as params to show email of user on account lock instruction page
  #Abhishek Singh On 13/06/2013
  # The path used after sending reset password instructions

  def after_sending_unlock_instructions_path_for(resource_name,resource)
    #US904 :
    #condition added for users except nusadmin so that it will redirect user to new page containg account lock info.
    # with user as params to display email on account lock message page.
    #Abhishek Singh On 13/06/2013
    if @is_nusadmin
      new_session_path(resource_name)
    else
      users_unlock_account_lock_message_path(:email=> resource.email)
    end
  end
  
  #US1438 Urvi 31-12-2014 moved the code from create method to make an individual method.
  def send_unlock_instructions_for_user
    self.resource = resource_class.send_unlock_instructions(params[resource_name])
    if successfully_sent?(resource)
      #US904: resource is sent as params to show email of user on account lock instruction page
      #Abhishek Singh On 13/06/2013
      respond_with({}, :location => after_sending_unlock_instructions_path_for(resource_name,resource))
    else
      respond_with_navigational(resource){ render :new }
    end  
  end

end
