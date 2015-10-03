class AddOrChangeTimesheets < ActiveRecord::Migration
  # def change
    # create_table :timesheets do |t|
    # t.integer  "employee_id"
    # t.datetime "date"
    # t.float    "hours"
    # t.string   "status"
    # t.text     "remarks"
    # t.text     "decline_remarks"
    # t.timestamps null: false
    # end
  # end
  
  
  def self.up
    rename_column :timesheets, :date, :from_date
    add_column :timesheets, :to_date, :datetime
  end

  def self.down
    rename_column :timesheets, :from_date, :date
    # rename back if you need or do something else or do nothing
  end
  
  
end
