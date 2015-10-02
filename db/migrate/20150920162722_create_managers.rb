class CreateManagers < ActiveRecord::Migration
  def change
    create_table :managers do |t|

      t.string :name
      # t.string :surname
      # t.string :email
      t.text :address
      t.string :phone
      # t.integer :raised_total
      
      t.timestamps null: false
    end
  end
end
