class ManagersController < ApplicationController
  before_action :set_manager, only: [:show, :edit, :update, :destroy]

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

  # GET /managers/1
  # GET /managers/1.json
  def show
  end

  # GET /managers/new
  def new
    @manager = Manager.new
  end

  def popup_declined
    # @interview_round = InterviewRound.where(id: params[:id]).first
    
    @timesheet = Timesheet.find_by(id: params[:manager_id])
    respond_to do |format|
      format.js
    end
  end

  # GET /managers/1/edit
  def edit
  end

  # POST /managers
  # POST /managers.json
  def create
    @manager = Manager.new(manager_params)

    respond_to do |format|
      if @manager.save
        format.html { redirect_to @manager, notice: 'Manager was successfully created.' }
        format.json { render :show, status: :created, location: @manager }
      else
        format.html { render :new }
        format.json { render json: @manager.errors, status: :unprocessable_entity }
      end
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

  # PATCH/PUT /managers/1
  # PATCH/PUT /managers/1.json
  def update
    respond_to do |format|
      if @manager.update(manager_params)
        format.html { redirect_to @manager, notice: 'Manager was successfully updated.' }
        format.json { render :show, status: :ok, location: @manager }
      else
        format.html { render :edit }
        format.json { render json: @manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /managers/1
  # DELETE /managers/1.json
  def destroy
    @manager.destroy
    respond_to do |format|
      format.html { redirect_to managers_url, notice: 'Manager was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manager
      @manager = Manager.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manager_params
      params[:manager]
    end
end
