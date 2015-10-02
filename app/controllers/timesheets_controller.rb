class TimesheetsController < ApplicationController
  before_action :set_timesheet, only: [:show, :edit, :update, :destroy]

  # GET /timesheets
  # GET /timesheets.json
  def index
    @timesheets = Timesheet.where(employee_id: current_employee.id)
    # @timesheet = Timesheet.new
  end

  # GET /timesheets/1
  # GET /timesheets/1.json
  def show
  end

  # GET /timesheets/new
  def new
    @timesheet = Timesheet.new
  end

  # GET /timesheets/1/edit
  def edit
  end

  # POST /timesheets
  # POST /timesheets.json
  def create
    @timesheet = Timesheet.new(timesheet_params)
    
    @timesheet.status = 'Pending Approval'

    respond_to do |format|
      if @timesheet.save
        format.html { redirect_to @timesheet, notice: 'Timesheet was successfully created.' }
        format.json { render :show, status: :created, location: @timesheet }
      else
        format.html { render :new }
        format.json { render json: @timesheet.errors, status: :unprocessable_entity }
      end
    end
  end

  


  # PATCH/PUT /timesheets/1
  # PATCH/PUT /timesheets/1.json
  def update
    respond_to do |format|
      if @timesheet.update(timesheet_params)
        format.html { redirect_to @timesheet, notice: 'Timesheet was successfully updated.' }
        format.json { render :show, status: :ok, location: @timesheet }
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
      format.html { redirect_to timesheets_url, notice: 'Timesheet was successfully approved.' }
      format.json { head :no_content }
    end
  end

  def reject
    timesheet = params[:timesheet]
    
    # timesheet_id = params[:timesheet_id]
    timesheet = Timesheet.find_by(timesheet_id)
    
    
    timesheet.status = 'Rejected'
    timesheet.save
    respond_to do |format|
      # redirect_to your_controller_action_url
      format.html { redirect_to managers_url, notice: 'Timesheet was successfully rejected.' }
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
      # params[:timesheet]
      
      # t.integer  "employee_id"
    # t.datetime "date"
    # # t.datetime "end_date"
    # t.float    "hours"
    # t.string   "status"
    # t.text     "remarks"
    # t.text     "decline_remarks"
      
      params.require(:timesheet).permit(:employee_id, :date, :hours, :status, :remarks, :decline_remarks)
    end
end
