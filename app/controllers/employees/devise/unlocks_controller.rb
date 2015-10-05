class Employees::Devise::UnlocksController < Devise::UnlocksController
  prepend_before_filter :require_no_authentication
  def create
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

  def account_lock_message()
    respond_with_navigational(resource){ render :account_lock_message }
  end

  protected

  def after_sending_unlock_instructions_path_for(resource_name,resource)
    if @is_nusadmin
      new_session_path(resource_name)
    else
      users_unlock_account_lock_message_path(:email=> resource.email)
    end
  end
  
  def send_unlock_instructions_for_user
    self.resource = resource_class.send_unlock_instructions(params[resource_name])
    if successfully_sent?(resource)
      respond_with({}, :location => after_sending_unlock_instructions_path_for(resource_name,resource))
    else
      respond_with_navigational(resource){ render :new }
    end  
  end
end
