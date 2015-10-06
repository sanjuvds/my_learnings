class ManagersController < ApplicationController
  before_action :authenticate_employee!
  def index
    @timesheet =initialize_grid(Timesheet, 
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
end
