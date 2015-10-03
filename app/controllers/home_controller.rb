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
    end
    
    if !employee_signed_in?
      redirect_to new_employee_session_url
    end
  end

  # GET /messages/new
  # def new
    # @message = Message.new(:parent_id => params[:parent_id])
  # end

  # GET /messages/1/edit
  # def edit
  # end

  # def create
    # @message = Message.new(message_params)
# 
    # respond_to do |format|
      # if @message.save
        # format.html { redirect_to @message, notice: 'Message was successfully created.' }
        # format.json { render :show, status: :created, location: @message }
      # else
        # format.html { render :new }
        # format.json { render json: @message.errors, status: :unprocessable_entity }
      # end
    # end
  # end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  # def update
    # respond_to do |format|
      # if @message.update(message_params)
        # format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        # format.json { render :show, status: :ok, location: @message }
      # else
        # format.html { render :edit }
        # format.json { render json: @message.errors, status: :unprocessable_entity }
      # end
    # end
  # end

  # DELETE /messages/1
  # DELETE /messages/1.json
  # def destroy
    # @message.destroy
    # respond_to do |format|
      # format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      # format.json { head :no_content }
    # end
  # end

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
