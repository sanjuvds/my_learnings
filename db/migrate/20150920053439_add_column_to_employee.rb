class AddColumnToEmployee < ActiveRecord::Migration
  def self.up
    add_column "employees", "is_manager", :boolean
    #add_column "employees", "manager_id", :integer
  end
  
  def self.down
    
  end
end