class CreateTimesheets < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
    t.integer  "employee_id"
    t.datetime "date"
    t.float    "hours"
    t.string   "status"
    t.text     "remarks"
    t.text     "decline_remarks"
    t.timestamps null: false
    end
  end
end
