class TimesheetsController < ApplicationController
  before_action :set_timesheet, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_employee!
  def index
    @timesheets = Timesheet.where(employee_id: current_employee.id)
  end

  def new
    @timesheet = Timesheet.new
  end

  def create
    @timesheet = Timesheet.new(timesheet_params)
    @timesheet.status = 'Pending Approval'
    from_date = params[:timesheet][:from_date]
    to_date = params[:timesheet][:to_date]
    respond_to do |format|
      if @timesheet.save
        format.html { redirect_to @timesheet, notice: 'Leave was successfully created.' }
        format.json { render :show, status: :created, location: @timesheet }
      else
        format.html { render :new }
        format.json { render json: @timesheet.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    # decline_remark = params[:timesheet][:decline_remarks]
    status = params[:timesheet][:status]
    respond_to do |format|
      if @timesheet.update(timesheet_params)
        if status.present? && status == "Rejected"
          format.html { redirect_to managers_url, notice: 'Leave application was successfully rejected.' }
          format.json { render :index, status: :ok, location: @timesheet }
        else
          format.html { redirect_to @timesheet, notice: 'Leave application was successfully updated.' }
          format.json { render :show, status: :ok, location: @timesheet }
        end
      else
        format.html { render :edit }
        format.json { render json: @timesheet.errors, status: :unprocessable_entity }
      end
    end
  end

  def approve
    timesheet_id = params[:timesheet_id]
    timesheet = Timesheet.find_by(id: timesheet_id)
    timesheet.status = 'Approved'
    timesheet.save
    respond_to do |format|
      format.html { redirect_to managers_url, notice: 'Leave application was successfully approved.' }
      format.json { head :no_content }
    end
  end

  def reject
    timesheet = params[:timesheet]
    timesheet = Timesheet.find_by(timesheet_id)
    timesheet.status = 'Rejected'
    timesheet.save
    respond_to do |format|
      format.html { redirect_to managers_url, notice: 'Leave was successfully rejected.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_timesheet
    @timesheet = Timesheet.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def timesheet_params
    params.require(:timesheet).permit(:employee_id, :from_date, :to_date, :status, :remarks, :decline_remarks)
  end
end
