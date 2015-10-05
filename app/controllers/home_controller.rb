class HomeController < ApplicationController
  before_action :set_message, only: [:edit, :update, :destroy]

  def index
  end

  def show
    if employee_signed_in?
      if current_employee.is_manager?
        redirect_to managers_url#(current_employee)
      else
        redirect_to timesheets_url
      end  
    else
      redirect_to new_employee_session_url
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:content, :parent_id)
    end
end
