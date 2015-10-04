class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :forname
      t.string :surname
      # t.string :email
      t.text :address
      t.text :phone
      t.integer :raised_total
      t.integer :manager_id
      
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      
      t.timestamps null: false
      # def self.up
   
    end
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
