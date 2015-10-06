class ManagersController < ApplicationController
  before_action :set_manager, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_employee!
  # GET /managers
  # GET /managers.json
  def index
    @timesheet =initialize_grid(Timesheet, 
      # :include => [:event_type ,:event_ticket_types],
      :conditions => ["status = ?", 'Pending Approval'],
      :order => 'from_date'
    )
    obj = Timesheet.where(status: 'Pending Approval')
    if obj.blank?
      @tsheet = Timesheet.new
    end
  end

  def reject
    timesheet = params[:timesheet]
    timesheet = Timesheet.find_by(timesheet_id)
    timesheet.status = 'Rejected'
    timesheet.save
    respond_to do |format|
      format.html { redirect_to managers_url, notice: 'Timesheet was successfully rejected.' }
      format.json { head :no_content }
    end
  end  
 
  private
    def set_manager
      @manager = Manager.find(params[:id])
    end

    def manager_params
      params[:manager]
    end
end
