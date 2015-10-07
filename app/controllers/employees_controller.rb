class EmployeesController < ApplicationController
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit(:forname, :surname, :email, :password, :password_confirmation, :avatar)
    end
end
